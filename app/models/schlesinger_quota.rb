# frozen_string_literal: true

# A quota is a schlesinger parameter for traffic
class SchlesingerQuota < ApplicationRecord
  include TrafficCalculations

  enum status: {
    awarded: '1',
    completed: '2',
    invoicing: '4',
    live: '5',
    api_manually_closed: '8',
    paused: '11'
  }

  belongs_to :survey
  has_one :onramp, dependent: :destroy
  has_one :project, through: :survey, inverse_of: :project
  has_many :onboardings, through: :onramp

  validates :cpi, :loi, :completes_wanted, :conversion_rate, :industry_id, :study_type_id, :sample_type_id, :start_date_time, :end_date_time, presence: true

  after_create_commit :retrieve_and_save_status
  after_create_commit :retrieve_and_save_name
  after_update_commit :update_schlesinger_survey

  def incidence_rate
    if onramp.present?
      denominator = onramp.complete_count + onramp.terminate_count
      denominator.zero? ? 0.0 : (onramp.complete_count.to_f / denominator * 100).round(2)
    else
      0.0
    end
  end

  def retrieve_and_save_status
    status = SchlesingerApi.new.get_survey_status(schlesinger_survey_id: schlesinger_survey_id)

    return if status.blank? || status.is_a?(Hash)

    update_column(:status, status) # rubocop:disable Rails/SkipsModelValidations
  end

  def retrieve_and_save_name
    name = SchlesingerApi.new.get_survey_name(schlesinger_survey_id: schlesinger_survey_id)

    return if name.blank? || name.is_a?(Hash)

    update_column(:name, name) # rubocop:disable Rails/SkipsModelValidations
  end

  def update_quota_status(status:)
    response_errors = SchlesingerApi.new.change_survey_status(body: SchlesingerApiPayload.new(schlesinger_object: self).change_survey_status_body(status))
    add_errors_if_present(response_errors)

    update_column(:status, status.downcase) if errors.messages.blank? # rubocop:disable Rails/SkipsModelValidations
  end

  def handle_soft_launch
    return if soft_launch_completes_wanted.blank?
    return if soft_launch_completed_at.present?
    return if onboardings.complete.count < soft_launch_completes_wanted

    update_column(:soft_launch_completed_at, Time.now.utc) # rubocop:disable Rails/SkipsModelValidations
    update_quota_status(status: 'paused')
  end

  def sync_status
    return if schlesinger_system_status.blank?
    return if schlesinger_system_status == status

    update_column(:status, schlesinger_system_status.downcase) # rubocop:disable Rails/SkipsModelValidations!
  end

  def schlesinger_system_status
    @status_id ||= SchlesingerApi.new.get_survey_status(schlesinger_survey_id: schlesinger_survey_id)
    return if @status_id.blank? || @status_id.is_a?(Hash)

    SchlesingerQuota.statuses.key(@status_id.to_s)
  end

  def self.status_id(status)
    statuses[status.to_sym]
  end

  def create_schlesinger_onramp
    survey.onramps.create(
      category: Onramp.categories[:schlesinger],
      schlesinger_quota: self,
      check_clean_id: false,
      check_recaptcha: true,
      check_gate_survey: false
    )
  end

  def create_schlesinger_project
    response = SchlesingerApi.new.create_project(body: SchlesingerApiPayload.new(schlesinger_object: self).project_body)
    add_errors_if_present(response)
    return if response.is_a?(Hash)

    response
  end

  def create_schlesinger_survey
    response = SchlesingerApi.new.create_survey(body: SchlesingerApiPayload.new(schlesinger_object: self).survey_body)
    add_errors_if_present(response)
    return if response.is_a?(Hash)

    response
  end

  def create_schlesinger_qualifications
    response = SchlesingerApi.new.create_qualifications(body: SchlesingerApiPayload.new(schlesinger_object: self).qualifications_body)
    add_errors_if_present(response)
    return if response.is_a?(Hash)

    response
  end

  def create_schlesinger_quota
    response = SchlesingerApi.new.create_quota(body: SchlesingerApiPayload.new(schlesinger_object: self).quota_body)
    add_errors_if_present(response)
    return if response.is_a?(Hash)

    response
  end

  def eligible_to_activate?
    status != 'live' && survey.live?
  end

  private

  def update_schlesinger_survey
    response = SchlesingerApi.new.update_survey(body: SchlesingerApiPayload.new(schlesinger_object: self).update_survey_body)
    add_errors_if_present(response)
    response
  end

  def add_errors_if_present(response)
    return unless response.is_a?(Hash)

    process_errors_hash(response)
    process_errors_string(response)
  end

  def process_errors_hash(response)
    return unless response[:errors].is_a?(Hash)

    response[:errors]&.values&.flatten&.each do |error|
      errors.add(:base, error)
    end
  end

  def process_errors_string(response)
    return if response[:errors].is_a?(Hash)

    response&.values&.flatten&.each do |error|
      errors.add(:base, error)
    end
  end
end
