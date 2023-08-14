# frozen_string_literal: true

# An onramp is the path that a user takes when starting a survey.
#   Encodes user IDs and tracks security checks.
class Onramp < ApplicationRecord
  include TrafficCalculations

  enum category: {
    testing: 'testing',
    recontact: 'recontact',
    panel: 'panel',
    expert_recruit: 'expert_recruit',
    client_sent: 'client_sent',
    vendor: 'vendor',
    router: 'router',
    api: 'api',
    disqo: 'disqo',
    cint: 'cint',
    schlesinger: 'schlesinger'
  }

  has_secure_token
  has_secure_token :bypass_token

  belongs_to :survey
  belongs_to :cint_survey, optional: true
  belongs_to :disqo_quota, optional: true
  belongs_to :schlesinger_quota, optional: true
  belongs_to :vendor_batch, optional: true
  belongs_to :api_vendor, optional: true, class_name: 'Vendor', inverse_of: :api_onramps
  belongs_to :panel, optional: true

  has_one :batch_vendor, through: :vendor_batch, source: :vendor, class_name: 'Vendor'
  has_one :project, through: :survey

  has_many :onboardings, dependent: :destroy
  has_many :complete_onboardings, -> { complete }, class_name: 'Onboarding', dependent: :destroy, inverse_of: :onramp
  has_many :complete_accepted_onboardings, -> { complete.accepted }, class_name: 'Onboarding', dependent: :destroy, inverse_of: :onramp
  has_many :complete_fraudulent_onboardings, -> { complete.fraudulent }, class_name: 'Onboarding', dependent: :destroy, inverse_of: :onramp
  has_many :complete_rejected_onboardings, -> { complete.rejected }, class_name: 'Onboarding', dependent: :destroy, inverse_of: :onramp
  has_many :accepted_onboardings, -> { accepted }, class_name: 'Onboarding', dependent: :destroy, inverse_of: :onramp
  has_many :fraudulent_onboardings, -> { fraudulent }, class_name: 'Onboarding', dependent: :destroy, inverse_of: :onramp
  has_many :rejected_onboardings, -> { rejected }, class_name: 'Onboarding', dependent: :destroy, inverse_of: :onramp
  has_many :complete_recorded_onboardings, -> { complete.where.not(client_status: nil) }, class_name: 'Onboarding', dependent: :destroy, inverse_of: :onramp
  has_many :client_sent_survey_invitations, dependent: :destroy
  has_many :prescreener_question_templates, through: :survey
  has_many :prescreener_questions, through: :onboardings

  after_update :notify_of_security_change

  scope :internal, -> { where(vendor_batch_id: nil) }
  scope :for_batch_vendor, ->(vendor) { joins(:vendor_batch).merge(VendorBatch.for_vendor(vendor)) }
  scope :for_api_vendor, ->(vendor) { where(api_vendor: vendor) }
  scope :order_by_category, lambda {
    order(
      Arel.sql(
        <<~HEREDOC
          CASE
            WHEN category='testing' THEN 1
            WHEN category='panel' THEN 2
            WHEN category='vendor' THEN 3
            WHEN category='api' THEN 4
            WHEN category='router' THEN 5
            WHEN category='recontact' THEN 6
          END
        HEREDOC
      )
    )
  }
  scope :has_prescreener_failures, -> { where(has_prescreener_failures: true) }

  delegate :draft?, :live?, :on_hold?, :loi, to: :survey
  delegate :uid_param, to: :vendor, allow_nil: true
  delegate :relevant_id_level, to: :project

  validates :category, presence: true
  validate :relationships_match_category
  validate :prescreener_question_templates_exist, if: :check_prescreener_changed?

  def vendor
    batch_vendor || api_vendor
  end

  def disqo_id
    disqo_quota&.quota_id || 'no quota found'
  end

  def source_model_name
    case category
    when 'panel'
      panel.name
    when 'vendor'
      vendor.name
    when 'router'
      'Survey router'
    when 'api'
      api_vendor.name
    end
  end

  def active?
    live? || on_hold?
  end

  def disable!
    update(disabled_at: Time.now.utc)
  end

  def enable!
    update(disabled_at: nil)
  end

  def disabled?
    disabled_at.present?
  end

  def editable?
    draft? || live? || on_hold?
  end

  def disableable?
    return false if disabled?

    if panel?
      active?
    elsif vendor?
      !vendor_batch.deletable? && active?
    else
      false
    end
  end

  def enableable?
    return false unless disabled?

    active?
  end

  def deletable?
    onboardings.empty?
  end

  def requires_security_checks?
    check_clean_id? || check_recaptcha?
  end

  def requires_no_security_checks?
    !requires_security_checks?
  end

  def secured?
    check_clean_id == true && check_recaptcha == true && !testing?
  end

  def webhook_allowed?
    return false if category.in?(%w[testing recontact panel disqo schlesinger cint expert_recruit])

    true
  end

  def prescreener_check_failures?
    has_prescreener_failures?
  end

  def prescreener_check_failure_summary
    failed_questions.each_with_object(Hash.new(0)) do |question, hash|
      hash[question] += 1
    end
  end

  def survey_url
    survey.base_link
  end

  # replaces the removed model relation for the table that still exists
  def survey_router
    { name: 'Survey router', amount_cents: 500 }
  end

  def failed_questions
    prescreener_questions.complete.failed.map(&:body)
  end

  def unaccepted_count
    unaccepted_accepted_count + unaccepted_fraudulent_count + unaccepted_rejected_count
  end

  def remaining_id_count
    return if onboardings.blank?

    complete_onboardings.size - complete_recorded_onboardings.size
  end

  def vendor_name
    return vendor.name if vendor.present?
    return unless cint? || disqo?

    cint? ? 'Cint' : 'Disqo'
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def to_csv
    CSV.generate do |csv|
      csv << %w[UID Status rejected_reason]
      onboardings.complete.each do |onboarding|
        values = [
          onboarding.uid,
          onboarding.project_closeout_status,
          onboarding.rejected_reason
        ]

        csv << values
      end
      onboardings.where.not(client_status: nil).find_each do |onboarding|
        next if onboarding.complete?

        values = [
          onboarding.uid,
          onboarding.project_closeout_status
        ]

        csv << values
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def unaccepted_accepted_count
    accepted_onboardings.size - complete_accepted_onboardings.size
  end

  def unaccepted_fraudulent_count
    fraudulent_onboardings.size - complete_fraudulent_onboardings.size
  end

  def unaccepted_rejected_count
    rejected_onboardings.size - complete_rejected_onboardings.size
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def relationships_match_category
    case category
    when 'testing' || 'router'
      errors.add(:vendor_batch, 'is not allowed') if vendor_batch.present?
      errors.add(:api_vendor, 'is not allowed') if api_vendor.present?
      errors.add(:panel, 'is not allowed') if panel.present?
    when 'panel'
      errors.add(:panel, 'is required') if panel.nil?
      errors.add(:vendor_batch, 'is not allowed') if vendor_batch.present?
      errors.add(:api_vendor, 'is not allowed') if api_vendor.present?
    when 'vendor'
      errors.add(:vendor, 'is required') if vendor.nil?
      errors.add(:api_vendor, 'is not allowed') if api_vendor.present?
      errors.add(:panel, 'is not allowed') if panel.present?
    when 'api'
      errors.add(:api_vendor, 'is required') if api_vendor.nil?
      errors.add(:vendor_batch, 'is not allowed') if vendor_batch.present?
      errors.add(:panel, 'is not allowed') if panel.present?
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  def prescreener_question_templates_exist
    return if prescreener_question_templates.active.exists?

    errors.add(:base, 'Please add prescreener questions before enabling')
  end

  def notify_of_security_change
    return unless saved_change_to_check_clean_id? || saved_change_to_check_recaptcha?
    return if check_clean_id == true && check_recaptcha == true

    EmployeeMailer.onramp_security_turned_off(self).deliver_later
  end
end
