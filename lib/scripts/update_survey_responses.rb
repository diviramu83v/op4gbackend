# frozen_string_literal: true

# rubocop:disable Rails/SkipsModelValidations
Onboarding.where.not(survey_response_pattern_id: nil).where(survey_response_id: nil).find_in_batches(batch_size: 100) do |batch|
  batch.each do |onboarding|
    response_id = onboarding.project&.responses&.find_by(survey_response_pattern_id: onboarding.survey_response_pattern_id)&.id
    next if response_id.blank?

    onboarding.update_column(:survey_response_url_id, response_id)
  end
end
# rubocop:enable Rails/SkipsModelValidations
