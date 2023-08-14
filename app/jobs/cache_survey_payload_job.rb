# frozen_string_literal: true

# Regularly refreshes the cache for the surveys API.
class CacheSurveyPayloadJob
  include Sidekiq::Worker

  def perform
    ApiToken.all.each do |token|
      payload = SurveyBatchPayload.build(token).map { |survey| SurveyPayload.build(survey, token) }.compact

      Rails.cache.write("api/v1/surveys/#{token.status}/#{token.vendor.id}/offer_payload", payload, expires_in: 15.minutes)

    rescue NoMethodError => e
      Rails.logger.warn "CacheSurveyPayloadJob: NoMethodError caught: #{e.message}"
    end
  end
end
