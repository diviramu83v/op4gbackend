# frozen_string_literal: true

# A survey response link is a URL that connects a survey to the type of
#   response we get back from a client for each panelist. Surveys will usually
#   have three links: complete/terminate/quotafull.
# TODO: Change to SurveyResponseURL? SurveyResponseLink?
class SurveyResponseUrl < ApplicationRecord
  has_secure_token

  enum slug: {
    complete: 'complete',
    terminate: 'terminate',
    quotafull: 'quotafull'
  }

  belongs_to :project

  has_many :onboardings, dependent: :nullify, inverse_of: :survey_response_url
  has_many :redirect_logs, dependent: :nullify, inverse_of: :survey_response_url

  # Make .token the default param in routing URLs.
  def to_param
    token
  end

  def name
    slug&.humanize
  end
end
