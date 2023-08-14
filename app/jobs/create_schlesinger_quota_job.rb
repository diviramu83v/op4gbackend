# frozen_string_literal: true

# This job creates schlesinger quotas
class CreateSchlesingerQuotaJob
  include Sidekiq::Worker
  sidekiq_options queue: 'ui'

  # rubocop:disable Rails/SkipsModelValidations
  def perform(survey_id, schlesinger_quota_params, clean_qualifications_params) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    quota_params = JSON.parse(schlesinger_quota_params)
    qualification_params = JSON.parse(clean_qualifications_params)
    survey = Survey.find(survey_id)

    data = ActiveRecord::Base.transaction do
      schlesinger_quota = survey.schlesinger_quotas.new(quota_params)
      schlesinger_quota.qualifications = qualification_params
      schlesinger_quota.create_schlesinger_onramp
      create_system_project_and_update_db(schlesinger_quota)
      create_system_survey_and_update_db(schlesinger_quota)
      create_system_qualifications(schlesinger_quota)
      create_system_quota_and_update_db(schlesinger_quota)
      schlesinger_quota.save! if schlesinger_quota.errors.messages.blank?

      raise ActiveRecord::Rollback if schlesinger_quota.errors.messages.any?
    end

    CreateSchlesingerQuotaChannel.broadcast_to('all', data)
  end

  def create_system_project_and_update_db(schlesinger_quota)
    schlesinger_quota.update_column(:schlesinger_project_id, schlesinger_quota.create_schlesinger_project) if schlesinger_quota.errors.messages.blank?
  end

  def create_system_survey_and_update_db(schlesinger_quota)
    schlesinger_quota.update_column(:schlesinger_survey_id, schlesinger_quota.create_schlesinger_survey) if schlesinger_quota.errors.messages.blank?
  end

  def create_system_qualifications(schlesinger_quota)
    schlesinger_quota.create_schlesinger_qualifications if schlesinger_quota.errors.messages.blank?
  end

  def create_system_quota_and_update_db(schlesinger_quota)
    schlesinger_quota.update_column(:schlesinger_quota_id, schlesinger_quota.create_schlesinger_quota) if schlesinger_quota.errors.messages.blank?
  end
  # rubocop:enable Rails/SkipsModelValidations
end
