# frozen_string_literal: true

# this is for the Cint API's Quota Feasibilities
class CintFeasibility < ApplicationRecord
  GENDER_CODES = { male: 1, female: 2 }.freeze

  belongs_to :employee

  validates :loi, :limit, :days_in_field, :incidence_rate, presence: true
  validates :loi, numericality: { less_than: 36 }
  validates :incidence_rate, numericality: { greater_than: 1, less_than: 101 }

  before_create :set_country
  after_create :create_cint_feasibility

  scope :most_recent, -> { order('created_at DESC') }

  def age_present?
    min_age.present? && max_age.present?
  end

  def all_options_for_country
    CintApi.new.country_demo_options(country_id: country_id)
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

  def postal_codes=(value)
    super(value == '' ? nil : value)
  end

  def formatted_postal_codes
    return [] if postal_codes.blank?

    postal_codes.delete(' ').split(',')
  end

  private

  def set_country
    self.country_id = 22
  end

  def create_cint_feasibility
    body = CintSurveyData.new(self).feasibility_body
    response = CintApi.new.create_survey_feasibility(body: body)

    update!(number_of_panelists: response)
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
end
