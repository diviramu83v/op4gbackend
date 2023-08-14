# frozen_string_literal: true

class BuildSurveyTestModeForEmployees < ActiveRecord::Migration[5.1]
  def change
    Employee.all.find_each(&:create_survey_test_mode)
  end
end
