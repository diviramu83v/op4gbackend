# frozen_string_literal: true

class RedirectLog < ApplicationRecord
  belongs_to :survey_response_url, inverse_of: :redirect_logs
  has_one :project, through: :survey_response_url

  scope :most_recent_first, -> { order(created_at: :desc) }
end
