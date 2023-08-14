# frozen_string_literal: true

# traffic steps show the next step for an onboarding
class TrafficStep < ApplicationRecord
  has_secure_token

  CLEANID_PRE = { sort_order: 1, when: 'pre', category: 'clean_id', status: 'incomplete' }.freeze
  RECAPTCHA_PRE = { sort_order: 2, when: 'pre', category: 'recaptcha', status: 'incomplete' }.freeze
  PRESCREENER_PRE = { sort_order: 3, when: 'pre', category: 'prescreener', status: 'incomplete' }.freeze
  GATE_PRE = { sort_order: 4, when: 'pre', category: 'gate_survey', status: 'incomplete' }.freeze
  ANALYZE_PRE = { sort_order: 5, when: 'pre', category: 'pre_analyze', status: 'incomplete' }.freeze

  ANALYZE_POST = { sort_order: 7, when: 'post', category: 'post_analyze', status: 'incomplete' }.freeze
  FOLLOWUP_POST = { sort_order: 8, when: 'post', category: 'follow_up', status: 'incomplete' }.freeze
  REDIRECT_POST = { sort_order: 9, when: 'post', category: 'redirect', status: 'incomplete' }.freeze

  enum status: {
    complete: 'complete',
    incomplete: 'incomplete'
  }

  belongs_to :onboarding

  has_one :onramp, through: :onboarding
  has_one :survey, through: :onboarding

  has_many :traffic_checks, dependent: :destroy

  scope :by_sort_order, -> { order('sort_order') }
  scope :pre_survey, -> { where(when: 'pre') }
  scope :post_survey, -> { where(when: 'post') }

  def complete_step
    raise StepAlreadyCompleted if complete?

    update(status: 'complete')
  end

  def create_traffic_check_event(method, ip, data_collected: nil)
    traffic_checks.create!(
      controller_action: method,
      data_collected: data_collected,
      status: 'N/A',
      ip_address: ip
    )
  end

  def pre?
    self.when == 'pre'
  end

  def failed?
    return false if skip_failure_checks?

    [
      checks_failed?,
      not_enough_checks?,
      took_too_long?,
      repeat_visit?
    ].any?(true)
  end

  def failed_reason
    case category
    when 'clean_id'
      clean_id_failed_reason
    when 'recaptcha'
      recaptcha_failed_reason
    end
  end

  # Create a hashed value that is based on:
  #   - the survey involved
  #   - whether the step is pre/post
  #   - the level set by the project manager (project/survey/onramp)
  # We want a unique value for every combination, but the same value for all
  #   traffic in a given scenario.
  def security_service_survey_id
    tokenize("#{survey.id}|#{self.when}|#{onramp.relevant_id_level}")
  end

  def self.generate_pre_steps(onboarding)
    steps = []

    steps << CLEANID_PRE if onboarding.run_cleanid_presurvey?
    steps << RECAPTCHA_PRE if onboarding.run_recaptcha_presurvey?
    steps << PRESCREENER_PRE if onboarding.run_prescreener?
    steps << GATE_PRE if onboarding.run_gate_survey?
    steps << ANALYZE_PRE

    steps
  end

  def self.generate_post_steps(onboarding)
    steps = []

    steps << ANALYZE_POST
    steps << FOLLOWUP_POST if onboarding.collect_followup_data? && !onboarding.expert_recruit?
    steps << REDIRECT_POST

    steps
  end

  def single_check?
    %w[record_response redirect].include?(category)
  end

  def elapsed_time
    times = traffic_checks.first(2).pluck(:created_at)
    times.max - times.min
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
  def formatted_category
    case category
    when /^clean_id/
      category.gsub('clean_id', 'CleanID')
    when /^recaptcha/
      category.gsub('recaptcha', 'Recaptcha')
    when /^gate_survey/
      category.gsub('gate_survey', 'Gate Survey')
    when /^analyze/
      category.gsub('analyze', 'Analyze')
    when /^pre_analyze/
      category.gsub('pre_analyze', 'Pre Analyze')
    when /^post_analyze/
      category.gsub('post_analyze', 'Post Analyze')
    when /^follow_up/
      category.gsub('follow_up', 'Follow Up')
    when /^record_response/
      category.gsub('record_response', 'Record Response')
    when /^redirect/
      category.gsub('redirect', 'Redirect')
    when /^prescreener/
      category.gsub('prescreener', 'Prescreener')
    else
      category
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity

  private

  def tokenize(input)
    Digest::SHA2.hexdigest(input)
  end

  def skip_failure_checks?
    case category
    when 'clean_id'
      onboarding.onramp.check_clean_id == false
    else
      false
    end
  end

  def checks_failed?
    traffic_checks.map(&:failed?).any?(true)
  end

  def not_enough_checks?
    case category
    when 'recaptcha' || 'clean_id'
      traffic_checks.count < 2
    end
  end

  def repeat_visit?
    case category
    when 'recaptcha' || 'clean_id'
      traffic_checks.count > 2
    end
  end

  def took_too_long?
    case category
    when 'clean_id'
      elapsed_time > 17
    when 'recaptcha'
      elapsed_time > 480
    end
  end

  def failed_clean_id_data
    traffic_checks.find(&:failed?).data_collected
  end

  def clean_id_failed_reason
    if checks_failed?
      verification = CleanIdDataVerification.new(data: failed_clean_id_data, onboarding: onboarding)
      verification.failed_reason
    else
      common_failed_reason
    end
  end

  def recaptcha_failed_reason
    if checks_failed?
      'recaptcha token invalid'
    else
      common_failed_reason
    end
  end

  def common_failed_reason
    %w[not_enough_checks? took_too_long? repeat_visit?].find do |check|
      send(check)
    end&.humanize&.downcase&.delete('?')
  end
end
