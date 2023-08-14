# frozen_string_literal: true

class BackfillStatusOnSurvey < ActiveRecord::Migration[5.2]
  def change
    Project.find_each do |project|
      project.surveys.find_each do |survey|
        survey.update_column(:status, project.status) # rubocop:disable Rails/SkipsModelValidations
      end
    end
  end
end
