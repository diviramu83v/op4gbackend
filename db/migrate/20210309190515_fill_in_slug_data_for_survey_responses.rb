# frozen_string_literal: true

class FillInSlugDataForSurveyResponses < ActiveRecord::Migration[5.2]
  def change
    SurveyResponseUrl.where.not(project_id: nil).find_each do |survey_response_url|
      pattern_id = survey_response_url.survey_response_pattern_id
      slug = SurveyResponsePattern.find(pattern_id).slug
      survey_response_url.update(slug: slug)
    end
  end
end
