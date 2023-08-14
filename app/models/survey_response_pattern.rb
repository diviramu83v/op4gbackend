# frozen_string_literal: true

# A survey response pattern stores one possible survey response. Used to
#   generate survey response links.
class SurveyResponsePattern < ApplicationRecord
  has_many :responses, dependent: :destroy, inverse_of: :survey_response_pattern, class_name: 'SurveyResponse'
  has_many :projects, through: :responses, inverse_of: :response_patterns

  scope :complete, -> { where(slug: 'complete') }
  scope :terminate, -> { where(slug: 'terminate') }
  scope :quotafull, -> { where(slug: 'quotafull') }

  def self.add_responses_to_project(project)
    find_each do |pattern|
      project.add_response(pattern)
    end
  end
end
