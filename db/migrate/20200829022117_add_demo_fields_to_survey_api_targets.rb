# frozen_string_literal: true

class AddDemoFieldsToSurveyApiTargets < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_api_targets, :education, :string, array: true
    add_column :survey_api_targets, :employment, :string, array: true
    add_column :survey_api_targets, :income, :string, array: true
    add_column :survey_api_targets, :race, :string, array: true
    add_column :survey_api_targets, :number_of_employees, :string, array: true
    add_column :survey_api_targets, :job_title, :string, array: true
    add_column :survey_api_targets, :organization_role, :string, array: true
    add_column :survey_api_targets, :custom_option, :string
  end
end
