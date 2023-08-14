# frozen_string_literal: true

class BackfillSurveyStatusTimestamps < ActiveRecord::Migration[5.2]
  def change
    Project.find_each do |project|
      project.surveys.find_each do |survey|
        survey.update_columns(finished_at: project.finished_at, # rubocop:disable Rails/SkipsModelValidations
                              started_at: project.started_at,
                              waiting_at: project.waiting_at)
      end
    end
  end
end
