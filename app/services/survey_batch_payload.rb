# frozen_string_literal: true

# Collects the right set of surveys for a specific token.
class SurveyBatchPayload
  def self.build(token)
    new(token).build
  end

  def initialize(token)
    @token = token
  end

  def build
    return Survey.live.available_on_api_sandbox if @token.sandbox?

    Survey.live.available_on_api
  end
end
