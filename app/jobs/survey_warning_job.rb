# frozen_string_literal: true

# Checks for surveys that are live with no sent batches
class SurveyWarningJob < ApplicationJob
  queue_as :default

  def perform
    SurveyWarning.create_warnings_for_live_projects_with_unsent_batches
  end
end
