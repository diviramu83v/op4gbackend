# frozen_string_literal: true

class FillInSurveyDataForOnramps < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations
  def change
    Onramp.all.find_each do |onramp|
      onramp.update_column(:survey_id, onramp.campaign.survey.id)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
