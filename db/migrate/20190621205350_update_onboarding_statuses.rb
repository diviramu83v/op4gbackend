# frozen_string_literal: true

# rubocop:disable Rails/SkipsModelValidations
class UpdateOnboardingStatuses < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def up
    Onboarding.find_each do |onboarding|
      next unless onboarding.initialized?

      if onboarding.failed_onboarding_at.present?
        onboarding.update_column('status', Onboarding.statuses[:blocked])
      elsif onboarding.survey_started_at.present? && onboarding.survey_finished_at.nil?
        onboarding.update_column('status', Onboarding.statuses[:survey_started])
      elsif onboarding.survey_started_at.present? && onboarding.survey_finished_at.present?
        onboarding.update_column('status', Onboarding.statuses[:survey_finished])
      end
    end
  end

  def down
    Onboarding.update_all(status: Onboarding.statuses[:initialized])
  end
end
# rubocop:enable Rails/SkipsModelValidations
