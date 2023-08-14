# frozen_string_literal: true

require 'ostruct'

# An onboarding is the record of one panelist entering a particular survey.
#   Handles things like checking RelevantID, Recaptcha, gate surveys, etc.
class Onboarding < ApplicationRecord
  include OnboardingBooleans
  nilify_blanks

  enum status: {
    initialized: 'initialized',
    blocked: 'blocked',
    screened: 'screened',
    survey_started: 'survey_started',
    survey_finished: 'survey_finished'
  }

  enum client_status: {
    accepted: 'accepted',
    rejected: 'rejected',
    fraudulent: 'fraudulent'
  }

  enum security_status: {
    secured: 'secured',
    unsecured: 'unsecured',
    verified: 'verified',
    other: 'other'
  }

  has_secure_token
  has_secure_token :onboarding_token
  has_secure_token :recaptcha_token
  has_secure_token :gate_survey_token
  has_secure_token :response_token
  has_secure_token :error_token

  belongs_to :onramp
  belongs_to :panel, optional: true
  belongs_to :panelist, optional: true
  belongs_to :survey_response_pattern, optional: true
  belongs_to :survey_response_url, optional: true, inverse_of: :onboardings
  belongs_to :project_invitation, optional: true
  belongs_to :recontact_invitation, optional: true
  belongs_to :ip_address, optional: true
  belongs_to :close_out_reason, optional: true

  has_one :earning, dependent: :restrict_with_exception
  has_one :survey, through: :onramp, inverse_of: :onboardings
  has_one :cint_survey, through: :onramp, inverse_of: :onboardings
  has_one :disqo_quota, through: :onramp, inverse_of: :onboardings
  has_one :schlesinger_quota, through: :onramp, inverse_of: :onboardings
  has_one :project, through: :onramp, inverse_of: :onboardings
  has_one :client, through: :project
  has_one :survey_api_target, through: :survey
  has_one :batch_vendor, through: :onramp, inverse_of: :onboardings, class_name: 'Vendor'
  has_one :api_vendor, through: :onramp, inverse_of: :onboardings, class_name: 'Vendor'
  has_one :gate_survey, inverse_of: :onboarding, dependent: :destroy
  has_one :vendor_batch, through: :onramp

  has_many :events, dependent: :destroy, inverse_of: :onboarding, class_name: 'TrafficEvent'
  has_many :decoded_uids, dependent: :destroy
  has_many :recontact_invitations, dependent: :destroy
  has_many :traffic_steps, dependent: :destroy
  has_many :traffic_checks, through: :traffic_steps
  has_many :prescreener_questions, dependent: :destroy
  has_many :traffic_events, dependent: :nullify
  has_many :return_key_onboardings, dependent: :destroy

  delegate :vendor, :category, :type, :panel?, :recontact?, :vendor?, :external?, :api?, :check_gate_survey?, to: :onramp
  delegate :draft?, :key_required?, to: :survey
  delegate :use_override_email?, :follow_up_wording, to: :batch_vendor, allow_nil: true
  delegate :secured?, to: :onramp, prefix: true

  validates :status, :security_status, presence: true
  validates :uid, presence: true
  validates :ip_address, presence: true, on: :create

  scope :testing, lambda {
                    where(project_invitation: nil)
                      .where(panel_id: nil)
                      .where(survey_router_source_id: nil)
                      .joins(:onramp).merge(Onramp.panel)
                  }
  scope :panel, -> { where.not(project_invitation: nil) }
  scope :router, -> { where.not(survey_router_source_id: nil) }

  scope :for_project, ->(project) { joins(:project).where('projects.id': project.id) if project.present? }
  scope :for_batch_vendor, ->(vendor) { joins(:onramp).merge(Onramp.for_batch_vendor(vendor)) }
  scope :for_api_vendor, ->(vendor) { joins(:onramp).merge(Onramp.for_api_vendor(vendor)) }
  scope :for_disqo, -> { joins(:onramp).merge(Onramp.where(category: 'disqo')) }
  scope :for_cint, -> { joins(:onramp).merge(Onramp.where(category: 'cint')) }

  scope :live, -> { where(initial_survey_status: 'live') }

  scope :in_survey, ->(loi) { survey_started.where('survey_started_at >= ?', Time.now.utc - (loi || 10).minutes) }
  scope :abandoned, ->(loi) { survey_started.where('survey_started_at < ?', Time.now.utc - (loi || 10).minutes) }
  scope :finished_recently, -> { survey_finished.where('survey_finished_at >= ?', 24.hours.ago) }
  scope :finished_in_past_eighteen_months, -> { survey_finished.where('survey_finished_at >= ?', 18.months.ago) }

  scope :complete, -> { survey_finished.joins(:survey_response_url).merge(SurveyResponseUrl.complete) }
  scope :terminate, -> { survey_finished.joins(:survey_response_url).merge(SurveyResponseUrl.terminate) }
  scope :quotafull, -> { survey_finished.joins(:survey_response_url).merge(SurveyResponseUrl.quotafull) }
  scope :for_survey_response_slug, lambda { |slug|
                                     if slug.present?
                                       survey_finished.joins(:survey_response_url)
                                                      .where(survey_response_urls: { slug: slug })
                                     end
                                   }

  scope :for_ids, ->(ids) { where(id: ids) }
  scope :with_followup_email_address, -> { where.not(email: nil) }

  scope :expert_recruit, -> { joins('INNER JOIN expert_recruits ON onboardings.uid = expert_recruits.token') }

  scope :most_recent_first, -> { order('created_at DESC') }
  scope :recently_screened, -> { screened.where('onboardings.updated_at > ?', Time.now.utc - 3.months) }

  scope :with_earnings, -> { left_joins(:earning).where.not('earnings.id' => nil) }
  scope :without_earnings, -> { left_joins(:earning).where(earnings: { id: nil }) }
  scope :nonpayment, -> { where(client_status: [:rejected, :fraudulent]) }
  scope :created_in_past_year, -> { where('onboardings.created_at > ?', 1.year.ago) }
  scope :for_year, ->(year) { where('onboardings.created_at between ? AND ?', Time.zone.local(year).beginning_of_year, Time.zone.local(year).end_of_year) }
  scope :for_month, ->(month) { where('onboardings.created_at between ? AND ?', month.beginning_of_month, month.end_of_month) }

  before_create :set_initial_survey_status
  after_create :add_prescreener_questions
  after_create :add_pre_survey_traffic_steps
  after_create :create_panelist_ip_history
  after_update :check_if_milestone_reached
  after_update :check_if_requested_completes_reached
  after_update :check_if_soft_launch_reached
  after_update :check_if_soft_launch_reached_for_schlesinger
  after_update :set_panelist_score

  def self.for_project_responses(project, slug)
    survey_finished.for_project(project).for_survey_response_slug(slug)
  end

  def button_label
    "Encoded UID : #{token}"
  end

  def source_name # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    return api_vendor.name if api_vendor.present?
    return batch_vendor.name if batch_vendor.present?
    return onramp.panel.name if onramp.panel?
    return 'Survey router' if survey_router_source_id.present?
    return disqo_quota&.name || backup_disqo_quota&.name if onramp.disqo?
    return cint_source_name if onramp.cint?
    return 'Testing' if onramp.testing?
    return 'Recontact' if onramp.recontact?

    'UNKNOWN DATA'
  end

  def source # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    return api_vendor if api_vendor.present?
    return batch_vendor if batch_vendor.present?
    return panel if panel.present?
    return disqo_quota || backup_disqo_quota if onramp.disqo?
    return cint_survey || backup_cint_survey if onramp.cint?
    return build_struct('Testing') if onramp.testing?
    return build_struct('Recontact') if onramp.recontact?

    build_struct('UNKNOWN DATA')
  end

  def build_struct(name)
    struct = Struct.new(:name)

    struct.new(name)
  end

  def backup_disqo_quota
    survey.disqo_quotas&.first
  end

  def backup_cint_survey
    survey.cint_surveys&.first
  end

  def cint_source_name
    if cint_survey.present?
      "Cint #{cint_survey.name}"
    else
      "Cint #{backup_cint_survey.name}"
    end
  end

  def expert_recruit_email
    expert_recruit = ExpertRecruit.find_by(token: uid)
    expert_recruit.email
  end

  def invitation
    return unless panel?

    ProjectInvitation.find_by(project: project, panelist: panelist)
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def survey_url_with_parameters
    if onramp.recontact?
      recontact_invitation = RecontactInvitation.find_by(token: uid)

      url = recontact_invitation.url
      return if url.blank?

      url = url.gsub('{{uid}}', token)
      url = url.gsub('{{old_uid}}', recontact_invitation.uid)
    else
      url = survey.base_link
      return if url.blank?

      url = url.gsub('{{uid}}', token)
      url = url.gsub('{{key}}', survey.next_key || 'add-keys') if key_required?
    end
    url
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def record_screened_event
    return unless initialized?

    screened!
  end

  def record_onboarding_completion
    return unless initialized?

    update(
      status: Onboarding.statuses[:survey_started],
      survey_started_at: Time.now.utc
    )
  end

  def set_security_status
    if panelist_verified?
      verified!
    elsif other_security_status?
      other!
    elsif onramp_secured?
      secured!
    else
      unsecured!
    end
  end

  def recaptcha_time_in_seconds
    return if recaptcha_started_at.nil?
    return if recaptcha_passed_at.nil?

    recaptcha_passed_at - recaptcha_started_at
  end

  def add_error(message)
    return unless initialized?

    update(
      error_message: message,
      status: Onboarding.statuses[:blocked],
      failed_onboarding_at: Time.now.utc
    )
  end

  def mark_flagged_post_survey(message)
    update(
      error_message: message,
      marked_fraud_at: Time.now.utc,
      failed_onboarding_at: Time.now.utc
    )
  end

  def mark_failed_post_survey(message)
    update(
      error_message: message,
      marked_post_survey_failed_at: Time.now.utc,
      failed_onboarding_at: Time.now.utc
    )
  end

  # rubocop:disable Metrics/MethodLength
  def record_survey_response(response)
    return unless survey_started?

    update(
      survey_response_url: response,
      status: Onboarding.statuses[:survey_finished],
      survey_finished_at: Time.now.utc
    )
    # rubocop:disable Rails/SkipsModelValidations
    project.touch # Invalidate the cache so the project completion count updates correctly.
    # rubocop:enable Rails/SkipsModelValidations

    record_cint_response
    project_invitation.try(:finished!)

    return if onramp.client_sent?

    call_vendor_webhook
  end

  def record_return_key(key_token)
    return if key_token.blank?

    return_key = ReturnKey.find_by(token: key_token)
    return if return_key.nil? # key does not exist

    # good or repeat
    return_key_onboardings.create!(return_key: return_key)
    return_key.used!
  end

  def call_vendor_webhook
    Webhook.new(onboarding: self).call_vendor_webhook
  end

  def check_for_ip_change(ip_to_check:)
    return false
    return if ip_address.nil?
    return if ip_to_check == ip_address

    record_fraud_event(message: "IP address changed for single traffic record. Original: #{ip_address.address}. Attempted: #{ip_to_check.address}.")

    logger.info "WATCHING: IP blocking: change in single traffic record: Original: #{ip_address.address}. Attempted: #{ip_to_check.address}."
  end

  def record_fraud_event(message:)
    events.create!(category: 'fraud', message: message)
    record_fraud_timestamp
  end

  def record_suspicious_event(message:)
    events.create!(category: 'suspicious', message: message)
  end

  def record_second_attempt
    update(attempted_again_at: Time.now.utc)
  end

  def record_fraud_timestamp
    update(
      fraud_attempted_at: Time.now.utc
    )
  end

  def length_of_interview
    return if survey_started_at.nil? || survey_finished_at.nil?

    survey_finished_at - survey_started_at
  end

  def length_of_interview_in_minutes
    return if length_of_interview.nil?

    length_of_interview / 60
  end

  def record_response_token_usage
    update(response_token_used_at: Time.now.utc)
  end

  def mark_webhook_sent
    update(webhook_notification_sent_at: Time.now.utc)
  end

  def payout
    if vendor?
      vendor_batch.incentive
    elsif api?
      survey.survey_api_target.payout
    elsif panel?
      project_invitation.incentive
    else
      'Uncalculated'
    end
  end

  # rubocop:disable Rails/FindEach, Metrics/AbcSize
  def self.to_csv
    CSV.generate do |csv|
      csv << ['Status', 'Type', 'Source',
              'Status', 'UID', 'Encoded UID',
              'Response', 'Final status', 'LOI in minutes', 'Survey start time',
              'Survey finish time', 'Age', 'Error Message'] # , 'Gender', 'Income', 'State']
      all.each do |onboarding|
        values = [
          onboarding.initial_survey_status,
          onboarding.category,
          onboarding.source_name,
          ApplicationController.helpers.onboarding_security_text(onboarding),
          onboarding.uid,
          onboarding.token,
          onboarding.survey_response_url.try(:slug),
          onboarding.client_status,
          onboarding.length_of_interview_in_minutes&.round(1),
          onboarding.survey_started_at&.in_time_zone('Central Time (US & Canada)')&.strftime('%Y-%m-%d %-I:%M %P %Z'),
          onboarding.survey_finished_at&.in_time_zone('Central Time (US & Canada)')&.strftime('%Y-%m-%d %-I:%M %P %Z'),
          onboarding.panelist.try(:age),
          onboarding.error_message
          # TODO: These panelist methods need to be refactored/updated once the data is finalized
          # onboarding.panelist.gender,
          # onboarding.panelist.income,
          # onboarding.panelist.state
        ]

        csv << values
      end
    end
  end
  # rubocop:enable Rails/FindEach, Metrics/MethodLength, Metrics/AbcSize

  def self.to_followup_csv
    CSV.generate do |csv|
      csv << ['Encoded UID', 'Email']
      all.find_each do |onboarding|
        values = [
          onboarding.token,
          onboarding.email
        ]

        csv << values
      end
    end
  end

  def self.to_completes_csv
    CSV.generate do |csv|
      csv << ['Email', 'Finished Date']

      all.find_each do |complete|
        csv << [complete.expert_recruit_email, complete.survey_finished_at.strftime('%m/%d/%Y')]
      end
    end
  end

  def self.find_by_unknown_token(token)
    record = find_by(token: token)
    return record unless record.nil?

    record = find_by(onboarding_token: token)
    return record unless record.nil?

    record = find_by(uid: token)
    return record unless record.nil?

    nil
  end

  def next_traffic_step_or_analyze
    traffic_steps.incomplete.by_sort_order.first || traffic_step_analyze_step
  end

  def response
    return if survey_response_url.blank?

    case survey_response_url.slug
    when 'complete' then project.complete_response
    when 'terminate' then project.terminate_response
    when 'quotafull' then project.quotafull_response
    end
  end

  def add_post_survey_traffic_steps
    return unless survey_finished?
    return if traffic_steps.post_survey.present?

    traffic_steps.create!(TrafficStep.generate_post_steps(self))
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create_panelist_earning
    return if panelist.nil?
    return unless earning.nil?

    if recontact?
      return if recontact_invitation.nil?

      amount = recontact_invitation.recontact_invitation_batch.incentive

      Earning.create!(onboarding: self, panelist: panelist, total_amount: amount)
    elsif panel?
      sample_batch = project_invitation.batch
      return if sample_batch.nil?

      amount = sample_batch.incentive

      Earning.create!(onboarding: self, panelist: panelist, sample_batch: sample_batch, total_amount: amount)
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def find_email_address
    panelist ? panelist.email : email
  end

  def complete_with_email?
    complete? && find_email_address.present?
  end

  def next_prescreener_question
    prescreener_questions.by_sort_order.incomplete&.first
  end

  def add_invitation_if_appropriate
    if recontact?
      invitation = RecontactInvitation.find_by(token: uid)
      return if invitation.blank?

      update!(recontact_invitation: invitation)
    elsif panel?
      invitation = ProjectInvitation.find_by(token: uid)
      return if invitation.blank?

      update!(project_invitation: invitation)
    end
  end

  # rubocop:disable Metrics/MethodLength
  def add_panelist_if_appropriate
    if recontact?
      invitation = RecontactInvitation.find_by(token: uid)
      return if invitation.blank?

      onboarding = invitation.original_onboarding

      panelist = onboarding.panelist
      return if panelist.blank?

      update!(panelist: panelist)
    elsif panel?
      invitation = ProjectInvitation.find_by(token: uid)
      return if invitation.blank?

      panelist = invitation.panelist
      return if panelist.blank?

      update!(panelist: panelist)
    end
  end
  # rubocop:enable Metrics/MethodLength

  def add_panel_if_appropriate
    return if recontact?
    return if panelist.blank?

    invitation = ProjectInvitation.find_by(token: uid)
    return if invitation.blank?

    sample_batch = SampleBatch.find_by(id: invitation.sample_batch_id)
    return if sample_batch.blank?

    update!(panel: sample_batch.panel)
  end

  def save_disqo_params(params)
    data = {}

    data[:clientId] = params[:clientId]
    data[:projectId] = params[:projectId]
    data[:quotaIds] = params[:quotaIds]
    data[:supplierId] = params[:supplierId]
    data[:tid] = params[:tid]
    data[:pid] = params[:pid]

    update!(api_params: data)
  end

  def save_schlesinger_params(params)
    data = {}
    data[:pid] = params[:pid]
    data[:token] = params[:token]
    Rails.logger.info("These are what the params look like: #{params}")

    update!(api_params: data)
  end

  def record_cint_response
    return unless onramp.cint?

    CintPostbackJob.perform_later(onboarding: self)
  end

  def self.disqo_completes_revenue_for_month(month:, year:)
    month = DateTime.parse("#{month}, #{year}")
    onboardings = Onboarding.complete.for_disqo.for_month(month)
    onboardings.sum { |onboarding| onboarding.survey.cpi || 0 }
  end

  def self.disqo_completes_payout_for_month(month:, year:)
    month = DateTime.parse("#{month}, #{year}")
    onboardings = Onboarding.complete.for_disqo.for_month(month)

    onboardings.sum do |onboarding|
      if onboarding.disqo_quota.present?
        onboarding.disqo_quota&.cpi.to_f || 0
      else
        onboarding.survey.disqo_quotas.first&.cpi.to_f || 0
      end
    end
  end

  def self.disqo_completes_profit_for_month(month:, year:) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    month = DateTime.parse("#{month}, #{year}")
    onboardings = Onboarding.complete.for_disqo.for_month(month)
    revenue = onboardings.sum { |onboarding| onboarding.survey.cpi.to_f || 0 }

    payout = onboardings.sum do |onboarding|
      if onboarding.disqo_quota.present?
        onboarding.disqo_quota&.cpi.to_f || 0
      else
        onboarding.survey.disqo_quotas.first&.cpi.to_f || 0
      end
    end

    revenue - payout
  end

  def self.cint_completes_revenue_for_month(month:, year:)
    month = DateTime.parse("#{month}, #{year}")
    onboardings = Onboarding.complete.for_cint.for_month(month)
    onboardings.sum { |onboarding| onboarding.survey.cpi.to_f || 0 }
  end

  def self.cint_completes_payout_for_month(month:, year:)
    month = DateTime.parse("#{month}, #{year}")
    onboardings = Onboarding.complete.for_cint.for_month(month)

    onboardings.sum do |onboarding|
      if onboarding.cint_survey.present?
        onboarding.cint_survey&.cpi.to_f || 0
      else
        onboarding.survey.cint_surveys.first&.cpi.to_f || 0
      end
    end
  end

  def self.cint_completes_profit_for_month(month:, year:) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    month = DateTime.parse("#{month}, #{year}")
    onboardings = Onboarding.complete.for_cint.for_month(month)
    revenue = onboardings.sum { |onboarding| onboarding.survey.cpi.to_f || 0 }

    payout = onboardings.sum do |onboarding|
      if onboarding.cint_survey.present?
        onboarding.cint_survey&.cpi.to_f || 0
      else
        onboarding.survey.cint_surveys.first&.cpi.to_f || 0
      end
    end

    revenue - payout
  end

  def clean_id_data
    traffic_steps&.where(category: 'clean_id')&.first&.traffic_checks
                 &.where(controller_action: 'show')&.first&.data_collected
  end

  def clean_id_data_valid?
    return false if clean_id_data.blank? || clean_id_data.is_a?(String) || clean_id_data.key?('error')

    true
  end

  def clean_id_score
    if clean_id_data&.key?('TransactionId')
      clean_id_data&.dig('Score') || 'n/a'
    else
      clean_id_data&.dig('forensic', 'marker', 'score') || 'n/a'
    end
  end

  def clean_id_full_set
    CleanIdApi.new(clean_id_data&.dig('TransactionId')).full_set
  end

  def project_closeout_status
    return 'remaining' if client_status.blank? && complete?
    return 'unaccepted' if client_status && !complete?

    client_status
  end

  private

  # The post-survey analyze step should only exist if we've gotten a response. Otherwise, we're still pre-survey.
  def traffic_step_analyze_step
    traffic_steps.post_survey.find_by(category: 'post_analyze') ||
      traffic_steps.pre_survey.find_by(category: 'pre_analyze') ||
      traffic_steps.pre_survey.find_by(category: 'analyze') # this last or is temporary
  end

  def create_panelist_ip_history
    return if panelist.blank? || ip_address.blank?

    PanelistIpHistory.create!(source: 'survey', panelist: panelist, ip_address: ip_address)
  end

  def check_if_milestone_reached
    return unless survey_finished?
    return unless survey_response_url&.slug == 'complete'

    survey.send_milestone_emails_and_set_status_to_hold
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
  def check_if_requested_completes_reached
    return unless vendor?
    return unless survey_response_url&.slug == 'complete'
    return if onramp.disabled?
    return if onramp&.vendor_batch&.requested_completes.blank?
    return unless onramp.complete_count >= onramp.vendor_batch.requested_completes

    onramp.disable!

    send_requested_completes_reached_email(onramp, onramp.vendor_batch.requested_completes)
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize

  def send_requested_completes_reached_email(onramp, requested_completes)
    EmployeeMailer.requested_completes_reached(onramp, requested_completes).deliver_later
  end

  def check_if_soft_launch_reached
    return unless survey_response_url&.slug == 'complete'
    return if disqo_quota.blank?

    disqo_quota.handle_soft_launch
  end

  def check_if_soft_launch_reached_for_schlesinger
    return unless survey_response_url&.slug == 'complete'
    return if schlesinger_quota.blank?

    schlesinger_quota.handle_soft_launch
  end

  def set_initial_survey_status
    self.initial_survey_status = survey.status
  end

  def add_prescreener_questions
    return unless onramp.check_prescreener?
    return if survey.prescreener_question_templates.blank?

    prescreener_questions.create!(PrescreenerQuestion.generate_questions(survey))
  end

  def add_pre_survey_traffic_steps
    traffic_steps.create!(TrafficStep.generate_pre_steps(self))
  end

  def set_panelist_score
    return unless saved_change_to_client_status? && panelist.present?

    CalculatePanelistScoreJob.perform_later(panelist: panelist)
  end
end
