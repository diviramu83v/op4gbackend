# frozen_string_literal: true

class AddProjectIdsToSurveyRecords < ActiveRecord::Migration[5.1]
  def up
    Survey.find_each do |survey|
      # rubocop:disable Rails/SkipsModelValidations
      survey.update_column('project_id', survey.campaign.project.id)
      # rubocop:enable Rails/SkipsModelValidations
    end
  end

  def down; end
end
