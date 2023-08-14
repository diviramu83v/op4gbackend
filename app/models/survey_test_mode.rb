# frozen_string_literal: true

# Determines if a user wants to bypass the survey
class SurveyTestMode < ApplicationRecord
  belongs_to :employee

  def easy_mode?
    easy_test == true
  end
end
