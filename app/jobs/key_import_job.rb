# frozen_string_literal: true

# Turns temporary survey keys into key records.
class KeyImportJob < ApplicationJob
  queue_as :default

  # TODO: Handle runtime errors.
  def perform(survey)
    # Prevent this from running multiple times by checking the temporary key value.
    survey.process_temporary_keys if survey.temporary_keys.present?
  end
end
