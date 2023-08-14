# frozen_string_literal: true

# A demographics query is used to target a specific group of panelists based
#   on information about them, either provided by them or derived by us.
class DemoQuery < ApplicationRecord
  belongs_to :panel
  belongs_to :country, optional: true
  belongs_to :survey, optional: true
  belongs_to :employee, optional: true
  belongs_to :client, optional: true

  has_one :project, through: :survey, inverse_of: :queries

  has_many :demo_questions_categories, through: :panel
  has_many :sample_batches, dependent: :destroy
  has_many :invitations, through: :sample_batches

  has_many :demo_query_options, dependent: :destroy
  has_many :options, through: :demo_query_options, source: :demo_option, inverse_of: :demo_queries

  has_many :demo_query_ages, dependent: :destroy
  has_many :ages, through: :demo_query_ages

  has_many :demo_query_state_codes, dependent: :destroy
  # has_many :state_codes, through: :demo_query_state_codes

  has_many :demo_query_regions, dependent: :destroy
  has_many :regions, through: :demo_query_regions, inverse_of: :queries

  has_many :demo_query_divisions, dependent: :destroy
  has_many :divisions, through: :demo_query_divisions, inverse_of: :queries

  has_many :demo_query_states, dependent: :destroy
  has_many :states, through: :demo_query_states, inverse_of: :queries

  has_many :demo_query_dmas, dependent: :destroy
  has_many :dmas, through: :demo_query_dmas, inverse_of: :queries

  has_many :demo_query_msas, dependent: :destroy
  has_many :msas, through: :demo_query_msas, inverse_of: :queries

  has_many :demo_query_pmsas, dependent: :destroy
  has_many :pmsas, through: :demo_query_pmsas, inverse_of: :queries

  has_many :demo_query_counties, dependent: :destroy
  has_many :counties, through: :demo_query_counties, inverse_of: :queries

  has_many :demo_query_zips, dependent: :destroy
  has_many :zip_codes, through: :demo_query_zips, inverse_of: :queries

  has_many :project_inclusions, dependent: :destroy, inverse_of: :demo_query, class_name: 'DemoQueryProjectInclusion'

  has_many :demo_query_onboardings, dependent: :destroy
  has_many :encoded_uid_onboardings, through: :demo_query_onboardings, source: :onboarding
  # has_many :encoded_uid_panelists, through: :encoded_uid_onboardings, source: :panelist #, class_name: 'Panelist'

  # has_many :demo_query_encoded_uid_panelists, dependent: :destroy
  # has_many :encoded_uid_panelists, through: :demo_query_encoded_uid_panelists, inverse_of: :encoded_uid_demo_queries, source: :panelist

  after_save :add_onramp

  delegate :countries, to: :panel

  scope :by_first_created, -> { order('created_at') }
  scope :most_recent, -> { order('created_at DESC') }
  scope :feasibility, -> { where(survey: nil) }

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def filtered?
    country.present? ||
      options.any? ||
      ages.any? ||
      demo_query_state_codes.any? ||
      regions.any? ||
      divisions.any? ||
      states.any? ||
      dmas.any? ||
      msas.any? ||
      pmsas.any? ||
      counties.any? ||
      zip_codes.any? ||
      project_inclusions.any? ||
      encoded_uid_onboardings.any?
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def panelists
    panel.panelists
         .active
         .for_country(country)
         .for_state_codes(demo_query_state_codes)
         .for_ages(ages)
         .for_options(options)
         .for_regions(regions)
         .for_divisions(divisions)
         .for_states(states)
         .for_dmas(dmas)
         .for_msas(msas)
         .for_pmsas(pmsas)
         .for_counties(counties)
         .for_zips(zip_codes)
         .for_project_inclusions(project_inclusions)
         .for_onboardings(encoded_uid_onboardings)
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def add_onramp
    return if survey.blank? || survey.onramps.pluck(:panel_id).include?(panel.id)

    Onramp.create(
      category: Onramp.categories[:panel],
      survey: survey,
      panel_id: panel.id,
      check_clean_id: true,
      check_recaptcha: true,
      check_gate_survey: false
    )
  end

  def panelist_count(cache: false)
    Rails.cache.fetch("query/#{id}/panelist_count", expires_in: 1.hour, force: !cache) do
      panelists.count
    end
  end

  def possible_states
    State.by_name - states
  end

  def possible_regions
    Region.by_name - regions
  end

  def possible_divisions
    Division.by_name - divisions
  end

  def possible_dmas
    Dma.by_name - dmas
  end

  def possible_msas
    Msa.by_name - msas
  end

  def possible_pmsas
    Pmsa.by_name - pmsas
  end

  def possible_counties
    County.by_name - counties
  end

  def possible_zips
    ZipCode.by_code - zips
  end

  def invitable_panelist_ids
    if survey.prevent_overlapping_invitations?
      invitable_panelist_ids_deduped_by_project
    else
      invitable_panelist_ids_deduped_by_survey
    end
  end

  def invitable_panelist_count(cache: false)
    Rails.cache.fetch("query/#{id}/invitable_panelist_ids_count", expires_in: 1.hour, force: !cache) do
      invitable_panelist_ids.count
    end
  end

  def questions
    all_questions - (binary_questions & selected_questions)
  end

  def possible_ages
    Age.all.order_by_value - ages
  end

  def possible_state_codes
    State::QUERY.values.flatten - selected_state_codes
  end

  def editable?
    sample_batches.empty?
  end

  def removable?
    sample_batches.empty?
  end

  def remove_country_specific_options
    options.delete options.for_country(country)
  end

  def most_recent_batch
    sample_batches.most_recent_first.limit(1).first
  end

  def closable_batches?
    closable_batches.any?
  end

  def close_batches
    closed_batches = closable_batches.each(&:close)
    return true if closed_batches.any?

    false
  end

  def next_sample_batch_fields
    {
      demo_query_id: id,
      count: invitable_panelist_count,
      incentive_cents: most_recent_batch.try(:incentive_cents), # Incentive empty on first batch.
      email_subject: 'Consumer Opinion Study',
      description: most_recent_batch.try(:description)
    }
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
  def recent_studies_with_matching_query(cache: true)
    Rails.cache.fetch("query/#{id}/recent_projects", force: !cache) do
      panel_demos = DemoQuery.where(panel_id: panel_id).where.not(survey_id: nil)
      matching_state_demos = panel_demos.select { |demo| demo.demo_query_state_codes.pluck(:code).sort == demo_query_state_codes.pluck(:code).sort }
      matching_state_age_demos = matching_state_demos.select { |demo| demo.demo_query_ages.pluck(:age_id).sort == demo_query_ages.pluck(:age_id).sort }
      options = demo_query_options.map { |q| q.demo_option.label }.sort
      matching_state_age_options_demos = matching_state_age_demos.select { |demo| demo.demo_query_options.map { |q| q.demo_option.label }.sort == options }
      matching_state_age_options_demos.map(&:survey).reverse.first(3)
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity

  def self.feasibility_employees
    feasibility.most_recent.joins(:employee).order('employees.last_name').map(&:employee).uniq
  end

  private

  def invitable_panelist_ids_deduped_by_project
    panelists.pluck(:id) - project.panelists.pluck(:id) - Panelist.panelist_ids_that_have_had_2_invitations_today - Panelist.unsubscribed
  end

  def invitable_panelist_ids_deduped_by_survey
    panelists.pluck(:id) - survey.invited_panelists.pluck(:id) - Panelist.panelist_ids_that_have_had_2_invitations_today - Panelist.unsubscribed
  end

  def closable_batches
    sample_batches.select(&:closable?)
  end

  def all_questions
    demo_questions_categories.by_sort_order.each_with_object([]) do |category, array|
      category.demo_questions.by_sort_order.each do |question|
        array << question
      end
    end
  end

  def binary_questions
    DemoQuestion.for_panel(panel).for_country(country).binary
  end

  def selected_questions
    DemoQuestion.for_panel(panel).for_country(country).for_options(options)
  end

  def selected_state_codes
    demo_query_state_codes.map(&:code)
  end
end
