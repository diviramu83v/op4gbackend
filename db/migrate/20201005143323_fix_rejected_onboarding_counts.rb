# frozen_string_literal: true

class FixRejectedOnboardingCounts < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def up
    survey_response_pattern_id = SurveyResponsePattern.find_by(slug: :complete)

    Onboarding
      .where(client_status: :rejected)
      .where.not(survey_response_pattern_id: survey_response_pattern_id)
      .or(Onboarding.where(client_status: :rejected)
      .where(survey_response_pattern_id: nil)).find_each do |onboarding|
      onboarding.update_columns(client_status: nil)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
