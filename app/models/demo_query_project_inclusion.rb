# frozen_string_literal: true

# Connects a query to project traffic with or without a certain response type.
class DemoQueryProjectInclusion < ApplicationRecord
  belongs_to :demo_query
  belongs_to :project
  belongs_to :survey_response_pattern, optional: true

  def button_label
    "Include project : #{project.id} / #{response_label}"
  end

  private

  def response_label
    return "#{slug.downcase}s" if slug.present?

    'all response types'
  end
end
