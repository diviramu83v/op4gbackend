# frozen_string_literal: true

class SetSurveyForAllKeys < ActiveRecord::Migration[5.1]
  def change
    Key.where(survey_id: nil).find_each do |key|
      key.update!(survey: key.campaign.survey)
    end
  end
end
