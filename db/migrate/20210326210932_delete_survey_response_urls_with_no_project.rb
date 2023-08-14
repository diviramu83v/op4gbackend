# frozen_string_literal: true

class DeleteSurveyResponseUrlsWithNoProject < ActiveRecord::Migration[5.2]
  def change
    SurveyResponseUrl.where(project_id: nil).find_each do |survey_response_url|
      SurveyResponseUrl.destroy(survey_response_url.id)
    end
  end
end
