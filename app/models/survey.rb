# frozen_string_literal: true

# We send panelists into a survey and are sent back responses based on the result
class Survey < ApplicationRecord
  include TrafficCalculations

  enum status: {
    draft: 'draft',
    live: 'live',
    hold: 'hold',
    waiting: 'waiting',
    finished: 'finished',
    archived: 'archived'
  }

  enum category: {
    standard: 'standard',
    recontact: 'recontact'
  }

  validates :category, presence: true

  NON_BLANK_FIELDS = %w[router_filter_gender router_filter_min_age router_filter_max_age].freeze

  before_save :nilify_blank_fields
  after_create :add_testing_onramp, :add_recontact_onramp, :assign_name

  after_update :deactivate_survey_warnings, if: :finished_or_archived?
  after_update :deactivate_complete_milestones
  after_update :update_project_started_at, if: :live?
  after_update :update_project_finished_at, if: :finished?
  after_update :close_disqo_projects_and_quotas, if: :finished?
  after_update :pause_disqo_projects_and_quotas, if: :hold_or_waiting?
  after_update :close_schlesinger_quotas, if: :finished?
  after_update :pause_schlesinger_quotas, if: :hold_or_waiting?

  belongs_to :project, touch: true
  belongs_to :country, optional: true

  has_many :expert_recruit_batches, dependent: :destroy
  has_many :expert_recruits, dependent: :nullify
  has_many :adjustments, dependent: :destroy, inverse_of: :survey, class_name: 'SurveyAdjustment'
  has_many :complete_milestones, dependent: :destroy
  has_many :return_keys, dependent: :destroy
  has_many :queries, dependent: :destroy, inverse_of: :survey, class_name: 'DemoQuery'
  has_many :sample_batches, through: :queries, inverse_of: :survey
  has_many :earnings, through: :sample_batches

  has_many :invitations, dependent: :destroy, class_name: 'ProjectInvitation'
  has_many :invited_panelists, through: :invitations, source: :panelist

  has_many :onramps, dependent: :destroy
  has_many :onboardings, through: :onramps
  has_many :ip_addresses, through: :onboardings
  has_many :gate_surveys, through: :onboardings, inverse_of: :survey
  has_many :prescreener_question_templates, dependent: :destroy
  has_many :survey_warnings, dependent: :destroy
  has_many :keys, dependent: :delete_all

  has_many :earnings_batches, dependent: :restrict_with_exception
  has_many :vendor_batches, dependent: :destroy
  has_many :vendors, through: :vendor_batches, inverse_of: :surveys
  has_many :traffic_reports, dependent: :destroy

  has_many :invitation_batches, class_name: 'RecontactInvitationBatch', dependent: :destroy, inverse_of: :survey
  has_many :recontact_invitations, through: :invitation_batches, inverse_of: :survey
  has_many :recontacted_onboardings, through: :recontact_invitations
  has_many :disqo_quotas, dependent: :nullify
  has_many :cint_surveys, dependent: :nullify
  has_many :schlesinger_quotas, dependent: :nullify

  has_one :survey_api_target, dependent: :destroy
  has_one :client_sent_survey, dependent: :destroy

  delegate :uid_parameter_key, to: :project

  validates :base_link, :target, :cpi, :loi, presence: true, if: :live_and_standard_category?
  validate :base_link_is_formatted_correctly

  validates :country_id, :audience, presence: true, on: :update, unless: -> { recontact? }

  has_secure_token

  scope :ordered_by_id, -> { order(:id) }
  scope :available_on_api, -> { joins(:survey_api_target).merge(SurveyApiTarget.active) }
  scope :available_on_api_sandbox, -> { joins(:survey_api_target).merge(SurveyApiTarget.sandbox) }
  scope :by_first_created, -> { order('created_at') }
  scope :disqo, -> { joins(:onramps).merge(Onramp.where(category: 'disqo')).distinct }
  scope :cint, -> { joins(:onramps).merge(Onramp.where(category: 'cint')).distinct }
  scope :schlesinger, -> { joins(:onramps).merge(Onramp.where(category: 'schlesinger')).distinct }
  scope :with_active_prescreener_questions, -> { joins(:prescreener_question_templates).where(prescreener_question_templates: { status: 'active' }) }
  scope :active, -> { live.or(hold).or(draft).or(waiting) }
  scope :active_not_draft, -> { live.or(hold).or(waiting) }
  scope :inactive, -> { draft.or(finished).or(archived).or(waiting) }
  scope :finished_for_30_days, lambda {
    finished.where('surveys.finished_at < ?', Time.now.utc - 30.days)
            .where('surveys.updated_at < ?', Time.now.utc - 30.days)
  }
  scope :finished_in_past_month, lambda {
    finished.where('surveys.finished_at >= ?', Time.now.utc.last_month)
  }
  scope :reportable_and_finished_within_90_days, lambda {
    where(
      '(finished_at >= ? and status = ?) OR status IN (?)',
      Time.now.utc - 90.days,
      'finished',
      %w[draft live hold waiting]
    )
  }

  monetize :cpi_cents, allow_nil: true

  # Intentionally overriding TrafficCalculations#traffic_records
  def traffic_records
    if recontact?
      draft? ? recontacted_onboardings : recontacted_onboardings.live
    else
      draft? ? onboardings : onboardings.live
    end
  end

  def removable?
    one_of_many? && draft? && sample_batches.empty?
  end

  def value
    target.blank? || cpi.blank? ? nil : target * cpi
  end

  def testing_onramp
    onramps.testing.first
  end

  def panel_onramps
    onramps.panel
  end

  def recontact_onramps
    onramps.recontact
  end

  def onramp_for_panel(panel)
    panel_onramps.find_by(panel: panel)
  end

  def onramp_for_recontact(recontact)
    recontact_onramps.find_by(survey: recontact)
  end

  # survey router model is removed; survey router db table is legacy
  def router_onramps
    onramps.where.not('onramps.survey_router_id' => nil)
  end

  def remaining_completes
    if target.blank?
      0
    else
      remaining_count = target - adjusted_complete_count
      remaining_count.negative? ? 0 : remaining_count
    end
  end

  def complete_count_adjusted?
    complete_count != adjusted_complete_count
  end

  def adjusted_complete_count
    complete_count + adjustment_total
  end

  def unaccepted_count
    unaccepted_accepted_count + unaccepted_fraudulent_count + unaccepted_rejected_count
  end

  def cint_survey_statuses
    cint_surveys.map(&:status)
  end

  def cint_incidence_rate
    denominator = cint_surveys.map { |cint_survey| cint_survey.complete_count + cint_survey.terminate_count }.sum
    cint_complete_count = cint_surveys.map(&:complete_count).sum
    return 0.0 if denominator.zero?

    (cint_complete_count.to_f / denominator * 100).round(2)
  end

  def clone_prescreener(survey)
    prescreener_question_templates.order(:id).each do |question|
      cloned_question = PrescreenerQuestionTemplate.create!(question_type: question.question_type,
                                                            passing_criteria: question.passing_criteria,
                                                            body: question.body,
                                                            survey: survey)
      question.clone_answers(cloned_question)
    end
  end

  def prescreener_check_failures?
    onramps.has_prescreener_failures.any?
  end

  def prescreener_check_failure_summary
    failed_questions.each_with_object(Hash.new(0)) do |question, hash|
      hash[question] += 1
    end
  end

  def some_prescreeners_on?
    onramps.any?(&:check_prescreener)
  end

  def some_prescreeners_off?
    onramps.any? { |onramp| onramp.check_prescreener == false }
  end

  def turn_prescreener_on
    onramps.each do |onramp|
      onramp.update!(check_prescreener: true, check_gate_survey: false)
    end
    true
  rescue StandardError
    false
  end

  def turn_prescreener_off
    onramps.each do |onramp|
      onramp.update!(check_prescreener: false)
    end
    true
  rescue StandardError
    false
  end

  def needs_missing_batch_warning?
    return false if survey_warnings.unsent_batches.any?
    return true if sample_batches.empty?

    sample_batches.all?(&:unsent?)
  end

  def send_milestone_emails_and_set_status_to_hold
    return unless live?

    complete_milestones.active.find_each do |milestone|
      next unless milestone.target_reached?

      milestone.survey.hold!
      milestone.send_milestone_email
    end
  end

  def add_query(query)
    queries << query
  end

  def keys_filename
    "project-#{project.id}-#{name.parameterize}-keys.csv"
  end

  def one_of_many?
    project.multiple_surveys?
  end

  # Returns count of keys receieved.
  # rubocop:disable Metrics/MethodLength
  def add_temporary_keys_from_csv(file_path)
    return 0 if temporary_keys.present?

    new_keys = []
    count = 0

    # Read each token from the first column of the CSV.
    CSV.foreach(file_path) do |row|
      next if row.blank?

      value = row.first.strip
      new_keys << value if value.present?

      count += 1
      break if count >= Key::IMPORT_LIMIT
    end

    # Save keys in array field for processing.
    update!(temporary_keys: new_keys)

    # Kick off import job.
    KeyImportJob.perform_later(self)

    temporary_keys.count
  end
  # rubocop:enable Metrics/MethodLength

  def process_temporary_keys
    while temporary_keys.any?
      key_block = temporary_keys.shift(1000)
      save!

      key_attrs = key_block.inject([]) do |a, value|
        a << { project_id: project_id, value: value, survey_id: id }
      end

      Key.import key_attrs, on_duplicate_key_ignore: true
    end

    update(temporary_keys: nil)
  end

  def add_key(value)
    keys.create(value: value, survey: self)
  rescue ActiveRecord::RecordNotUnique
    false
  end

  def downloadable_keys?
    keys.any?
  end

  def removable_keys?
    unused_keys.any?
  end

  def unused_keys
    keys.unused
  end

  def keys?
    keys.any?
  end

  def key_required?
    keys.any? || temporary_keys.present?
  end

  def used_keys
    keys.used
  end

  def next_key
    return if keys.empty?

    key = keys.lock('FOR UPDATE SKIP LOCKED').unused.by_created_at.first

    return if key.blank?

    key.update!(used_at: Time.now.utc)
    key.value
  end

  # rubocop:disable Metrics/AbcSize
  def traffic_with_block_reasons
    onramps.each_with_object({}) do |onramp, outer_hash|
      next if onramp.testing?

      onboardings = onramp.onboardings.blocked
      new_hash = onboardings.each_with_object(Hash.new(0)) do |onboarding, hash|
        hash[format_error_message(onboarding.error_message)] += 1
      end
      outer_hash[onramp] = new_hash.sort_by { |_k, v| -v }.to_h
    end
  end
  # rubocop:enable Metrics/AbcSize

  def possible_vendors
    Vendor.active.by_name - vendors
  end

  def editable?
    draft? || live? || hold? || waiting?
  end

  def active?
    draft? || live? || hold? || waiting?
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def to_csv
    CSV.generate do |csv|
      csv << %w[New Previous Email Source Payout]

      recontacted_onboardings.complete.find_each do |onboarding|
        csv << [
          onboarding.token,
          onboarding.recontact_invitation.uid,
          onboarding.recontact_invitation.original_onboarding.find_email_address,
          onboarding.recontact_invitation.original_onboarding.source_name,
          "$#{onboarding.recontact_invitation.recontact_invitation_batch.incentive}"
        ]
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def uses_return_keys?
    return_keys.present?
  end

  def language_code
    return 'en' if language.nil?

    code = {
      'English' => 'en',
      'French (Canadian)' => 'fr-CA',
      'Chinese' => 'zh-TW'
    }

    code[language]
  end

  def on_hold?
    hold?
  end

  def live_or_on_hold?
    live? || hold?
  end

  def hold_or_waiting?
    hold? || waiting?
  end

  def finished_or_archived?
    finished? || archived?
  end

  # rubocop:disable Metrics/AbcSize
  def assign_status(slug)
    Rails.logger.info "survey: #{id} :: #{status} => #{slug}"
    assign_attributes(status: slug)
    assign_attributes(started_at: Time.now.utc) if started_at.blank? && live?
    assign_attributes(finished_at: Time.now.utc) if finished?
    assign_attributes(waiting_at: Time.now.utc) if waiting?
  rescue ArgumentError
    false
  end
  # rubocop:enable Metrics/AbcSize

  def clean_stale_invitations
    return unless finished?
    return if updated_within_30_days?

    sent_invitations = invitations.sent
    project.update_column(:deleted_sent_invitations_count, sent_invitations.count) # rubocop:disable Rails/SkipsModelValidations

    invitations.sent.delete_all
  end

  def self.clean_stale_invitations
    finished_for_30_days.find_each(&:clean_stale_invitations)
  end

  def updated_within_30_days?
    updated_at > thirty_days_ago
  end

  def thirty_days_ago
    Time.now.utc - 30.days
  end

  def delete_old_keys
    return if active_within_30_days?

    deleted_count = keys.unused.delete_all
  end

  def self.delete_old_keys
    inactive.find_each(&:delete_old_keys)
  end

  def active_within_30_days?
    return true if active?
    return true if updated_within_30_days?

    false
  end

  def remaining_id_count
    return if onboardings.blank?

    recorded_ids = onboardings.complete.where.not(client_status: nil).count

    onboardings.complete.count - recorded_ids
  end

  def invitations_for_panel(panel:)
    query_ids = queries.pluck(:id)
    batch_ids = panel.sample_batches.where(demo_query_id: query_ids).pluck(:id)
    invitations.where(sample_batch_id: batch_ids)
  end

  def update_project_started_at
    return unless able_to_update_project_started_at?

    # rubocop:disable Rails/SkipsModelValidations
    project.update_column(:started_at, started_at) if project.started_at.blank? || started_at < project.started_at
    project.update_column(:finished_at, nil) if project.finished_at.present?
    # rubocop:enable Rails/SkipsModelValidations
  end

  def update_project_finished_at
    return unless able_to_update_project_finished_at?

    # rubocop:disable Rails/SkipsModelValidations
    project.update_column(:finished_at, finished_at) if project.finished_at.blank? || finished_at > project.finished_at
    # rubocop:enable Rails/SkipsModelValidations
  end

  def close_disqo_projects_and_quotas
    disqo_quotas.each do |disqo_quota|
      disqo_quota.update_quota_status(status: 'PAUSED')
      disqo_quota.update_project_status(status: 'CLOSED')
    end
  end

  def pause_disqo_projects_and_quotas
    disqo_quotas.each do |disqo_quota|
      disqo_quota.update_quota_status(status: 'PAUSED')
      disqo_quota.update_project_status(status: 'HOLD')
    end
  end

  def close_schlesinger_quotas
    schlesinger_quotas.each do |schlesinger_quota|
      schlesinger_quota.update_quota_status(status: 'completed')
    end
  end

  def pause_schlesinger_quotas
    schlesinger_quotas.each do |schlesinger_quota|
      schlesinger_quota.update_quota_status(status: 'paused')
    end
  end

  def cloneable_fields # rubocop:disable Metrics/MethodLength
    {
      name: "#{name} - Clone",
      base_link: base_link,
      category: category,
      loi: loi,
      target: target,
      cpi_cents: cpi_cents,
      audience: audience,
      country_id: country_id,
      language: language,
      prevent_overlapping_invitations: prevent_overlapping_invitations
    }
  end

  def clone_survey
    if vendor_batches.present?
      survey_clone = project.add_survey_clone(self)
      clone_vendor_batches(survey_clone)
    else
      project.add_survey_clone(self)
    end
  end

  private

  def unaccepted_accepted_count
    onboardings.accepted.count - onboardings.complete.accepted.count
  end

  def unaccepted_fraudulent_count
    onboardings.fraudulent.count - onboardings.complete.fraudulent.count
  end

  def unaccepted_rejected_count
    onboardings.rejected.count - onboardings.complete.rejected.count
  end

  def failed_questions
    onramps.map(&:failed_questions).flatten
  end

  def live_and_standard_category?
    live? && standard?
  end

  def able_to_update_project_started_at?
    live? && started_at.present?
  end

  def able_to_update_project_finished_at?
    finished? && finished_at.present? && project.surveys.active.blank?
  end

  def assign_name
    return unless recontact?

    count = project.surveys.recontact.count
    update!(name: "Recontact #{count}")
  end

  def adjustment_total
    adjustments.sum(:offset)
  end

  def add_testing_onramp
    return if onramps.testing.any?

    Onramp.create!(
      category: Onramp.categories[:testing],
      survey: self,
      check_clean_id: true,
      check_recaptcha: true,
      check_gate_survey: false
    )
  end

  def add_recontact_onramp
    return unless recontact?

    Onramp.create!(
      category: Onramp.categories[:recontact],
      survey: self,
      check_clean_id: true,
      check_recaptcha: true,
      check_gate_survey: false
    )
  end

  # TODO: Use nilify_blanks gem to replace this code.
  def nilify_blank_fields
    NON_BLANK_FIELDS.each { |attr| self[attr] = nil if self[attr].blank? }
  end

  def base_link_is_formatted_correctly
    return if base_link.blank?

    errors.add(:base_link, 'must begin with "http://" or "https://"') unless base_link.start_with?('http://', 'https://')
    errors.add(:base_link, 'must include {{uid}}') unless base_link.include? '{{uid}}'
    errors.add(:base_link, 'must not contain any spaces') if base_link.match?(/\s/)
  end

  def format_error_message(message)
    message.sub!('failed: ', '')
    message.humanize
  end

  def deactivate_survey_warnings
    survey_warnings.active.find_each(&:mark_as_inactive)
  end

  def deactivate_complete_milestones
    return unless finished?
    return if active?

    complete_milestones.find_each(&:mark_as_deactivated)
  end

  def clone_vendor_batches(survey_clone)
    vendor_batches.each do |vendor_batch|
      vendor_batch_clone = survey_clone.vendor_batches.new(vendor_batch.cloneable_fields)
      next unless vendor_batch_clone.save
    end
  end
end
