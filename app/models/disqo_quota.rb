# frozen_string_literal: true

# A quota is a disqo parameter for traffic
class DisqoQuota < ApplicationRecord
  include DisqoQuotaQualifications

  enum status: {
    live: 'live',
    paused: 'paused'
  }

  belongs_to :survey
  has_one :onramp, dependent: :destroy
  has_one :project, through: :survey, inverse_of: :project
  has_many :onboardings, through: :onramp

  validates :cpi, :loi, :completes_wanted, :status, :conversion_rate, presence: true

  after_create :create_onramp_and_quota
  after_update :update_disqo_project_and_quota

  def name
    "Disqo #{quota_id}"
  end

  def incidence_rate
    if onramp.present?
      denominator = onramp.complete_count + onramp.terminate_count
      denominator.zero? ? 0.0 : (onramp.complete_count.to_f / denominator * 100).round(2)
    else
      0.0
    end
  end

  def create_onramp_and_quota
    create_disqo_onramp
    set_quota_id
    create_disqo_project_and_quota
    raise ActiveRecord::Rollback if errors.messages.any?
  end

  def update_quota_status(status:)
    response_errors = DisqoApi.new.change_project_quota_status(
      project_id: quota_id,
      quota_id: quota_id,
      status: status
    )

    response_errors&.each do |error|
      errors.add(:base, error['message'])
    end

    update_column(:status, status.downcase) if response_errors.blank? # rubocop:disable Rails/SkipsModelValidations
  end

  def update_project_status(status:)
    response_errors = DisqoApi.new.update_project_status(
      project_id: quota_id,
      status: status
    )

    response_errors&.each do |error|
      errors.add(:base, error['message'])
    end
  end

  def disqo_project_quota_id
    onramp&.id || "#{survey.onramps.disqo.first.id}-#{survey.disqo_quotas.count + 1}"
  end

  def disqo_onramp
    onramp || survey.onramps.disqo.first
  end

  def sync_status
    return if disqo_quota_system_status.blank?
    return if disqo_quota_system_status.downcase == status

    update_quota_status(status: 'PAUSED')
    update_project_status(status: 'HOLD')
  end

  def disqo_quota_system_status
    DisqoApi.new.get_quota_status(quota: self)
  end

  def disqo_project_system_status
    DisqoApi.new.get_project_status(quota: self)
  end

  def handle_soft_launch
    return if soft_launch_completes_wanted.blank?
    return if soft_launch_completed_at.present?
    return if onboardings.complete.count < soft_launch_completes_wanted

    update_column(:soft_launch_completed_at, Time.now.utc) # rubocop:disable Rails/SkipsModelValidations
    update_quota_status(status: 'PAUSED')
    update_project_status(status: 'HOLD')
  end

  def eligible_to_activate?
    survey.live? && status != 'live' && disqo_project_system_status != 'CLOSED'
  end

  private

  def create_disqo_onramp
    survey.onramps.create(
      category: Onramp.categories[:disqo],
      disqo_quota: self,
      check_clean_id: true,
      check_recaptcha: true,
      check_gate_survey: false
    )
  end

  def create_disqo_project_and_quota
    project_errors = DisqoApi.new.create_project(body: DisqoApiPayload.new(disqo_object: self).project_body.to_json)
    if project_errors.blank?
      update_project_status(status: 'HOLD')
      quota_errors = DisqoApi.new.create_project_quota(project_id: disqo_project_quota_id,
                                                       body: DisqoApiPayload.new(disqo_object: self).project_quota_body.to_json)
    end
    add_errors_if_present(project_errors, quota_errors)
  end

  def update_disqo_project_and_quota
    project_errors = DisqoApi.new.update_project(project_id: quota_id, body: DisqoApiPayload.new(disqo_object: self).project_body.to_json)
    if project_errors.blank?
      quota_errors = DisqoApi.new.update_project_quota(project_id: quota_id,
                                                       quota_id: quota_id,
                                                       body: DisqoApiPayload.new(disqo_object: self).project_quota_body.to_json)
    end
    add_errors_if_present(project_errors, quota_errors)
  end

  def add_errors_if_present(project_errors, quota_errors)
    add_errors_from_array(project_errors)
    add_errors_from_array(quota_errors)
  end

  def add_errors_from_array(array)
    array&.each do |error|
      errors.add(:base, error)
    end
  end

  def set_quota_id
    update_column(:quota_id, disqo_project_quota_id) # rubocop:disable Rails/SkipsModelValidations
  end
end
