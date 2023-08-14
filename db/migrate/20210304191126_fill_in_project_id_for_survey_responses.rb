# frozen_string_literal: true

class FillInProjectIdForSurveyResponses < ActiveRecord::Migration[5.2]
  def change
    Project.find_each do |project|
      project.surveys.order(:id).first.responses.find_each do |response|
        response.update(project: project)
      end
    end
  end
end
