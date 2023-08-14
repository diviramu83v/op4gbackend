# frozen_string_literal: true

# A cint survey has quota parameters for the cint api
class CintSurvey < ApplicationRecord
  include TrafficCalculations
  GENDER_CODES = { male: 1, female: 2 }.freeze

  enum status: {
    draft: 'draft',
    activation_failed: 'activation_failed',
    waiting: 'waiting',
    live: 'live',
    paused: 'paused',
    halted: 'halted',
    complete: 'complete',
    closed: 'closed'
  }

  has_one :onramp, dependent: :destroy
  has_one :project, through: :survey, inverse_of: :project
  has_many :onboardings, through: :onramp
  has_many :cint_events, dependent: :nullify

  belongs_to :survey

  validates :loi, :limit, :expected_incidence_rate, :name, presence: true
  validates :loi, numericality: { less_than: 36 }
  validates :expected_incidence_rate, numericality: { greater_than: 1, less_than: 101 }
  validate :update_limit, :update_cpi, on: :update

  before_create :format_postal_codes
  before_create :calculate_cpi
  before_create :set_country
  after_create :add_onramp

  monetize :cpi_cents, allow_nil: true

  def create_cint_survey_and_add_cint_id
    body = CintSurveyData.new(self).survey_body
    response = CintApi.new.create_survey(body: body)
    if response == '0'
      update(cint_id: response, status: :activation_failed)
    else
      update(cint_id: response, status: :waiting, activated_at: Time.now.utc)
    end
  end

  # rubocop:disable Rails/SkipsModelValidations
  def update_status(status:)
    api_status = 1 if status == 'live'
    api_status = 2 if status == 'paused'

    response_errors = CintApi.new.change_survey_status(
      survey_id: cint_id,
      status: api_status
    )

    response_errors&.each do |error|
      errors.add(:base, error['message'])
    end

    update_column(:status, status.downcase) if response_errors.blank?
  end
  # rubocop:enable Rails/SkipsModelValidations

  def update_cpi
    return unless cpi_cents_changed?
    return if cint_id.blank?

    response_errors = CintApi.new.change_survey_cpi(
      survey_id: cint_id,
      cpi: cpi.to_f
    )

    response_errors&.each do |error|
      errors.add(:base, "#{error['field']} #{error['message']}")
    end
  end

  def update_limit
    return unless limit_changed?
    return if cint_id.blank?

    response_errors = CintApi.new.change_survey_limit(
      survey_id: cint_id,
      limit: limit
    )

    response_errors&.each do |error|
      errors.add(:base, "#{error['field']} #{error['message']}")
    end
  end

  def all_options_for_country
    CintApi.new.country_demo_options(country_id: cint_country_id)
  end

  def option_variables_hash
    options_and_variables = Hash.new { |h, k| h[k] = [] }
    all_options_for_country.each do |option|
      option['variables'].each do |variable|
        options_and_variables[option['name']] << variable['name'] if variable_ids.include?(variable['id'].to_s)
      end
    end
    options_and_variables
  end

  def state_names
    return if region_ids.blank?

    states = build_state_options
    state_names = []
    states.each do |state|
      state_names << state['name'] if region_ids.include?(state['id'].to_s)
    end
    state_names
  end

  def city_names
    return if region_ids.blank?

    cities = build_city_options
    city_names = []
    cities.each do |city|
      city_names << city['name'] if region_ids.include?(city['id'].to_s)
    end
    city_names
  end

  def display_cint_id
    cint_id || '?'
  end

  def activated?
    activated_at.present?
  end

  def completable?
    activated? && (live? || paused? || halted?)
  end

  def editable?
    activated? && (live? || waiting? || paused? || halted?)
  end

  def age_present?
    min_age.present? && max_age.present?
  end

  def calculate_cpi
    self.cpi_cents = CintCpiCalculator.new(loi: loi, incidence_rate: expected_incidence_rate).calculate!
  end

  def postal_codes=(value)
    super(value == '' ? nil : value)
  end

  def formatted_postal_codes
    return [] if postal_codes.blank?

    postal_codes.delete(' ').split(',')
  end

  def name_with_safeguard
    return name if name.present?

    'Cint Quota'
  end

  private

  def format_postal_codes
    return unless postal_codes

    self.postal_codes = postal_codes.gsub(/\r\n?/, '')
  end

  def set_country
    self.cint_country_id = 22
  end

  def build_state_options
    region_types = build_region_types
    @states = []
    region_types[0][4]['regions'].each do |state|
      @states.push({ name: state['name'], id: state['id'] })
    end
  end

  def build_city_options
    region_types = build_region_types
    @cities = []
    region_types[0][3]['regions'].each do |city|
      @cities.push({ name: city['name'], id: city['id'] })
    end
  end

  def build_region_types
    countries = CintApi.new.countries_hash
    region_types = []
    countries.each do |country|
      next unless country['name'] == 'USA'

      region_types.push(country['regionTypes'])
    end
    region_types
  end

  def add_onramp
    Onramp.create!(
      category: Onramp.categories[:cint],
      survey: survey,
      cint_survey: self,
      check_clean_id: true,
      check_recaptcha: true,
      check_gate_survey: false
    )
  end
end
