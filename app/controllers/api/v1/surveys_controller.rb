# frozen_string_literal: true

class Api::V1::SurveysController < Api::BaseController
  # rubocop:disable Metrics/AbcSize
  def index
    # API timeout debugging
    Rails.logger.info("Survey API request started for vendor; status: #{@token.status}, id: #{@token.vendor.id}")

    offers = Rails.cache.fetch("api/v1/surveys/#{@token.status}/#{@token.vendor.id}/offer_payload",
                               expires_in: 1.hour, race_condition_ttl: 1.minute, force: false) do
      # API timeout debugging
      Rails.logger.info("Survey API request cache miss for vendor; status: #{@token.status}, id: #{@token.vendor.id}")

      SurveyBatchPayload.build(@token).map { |survey| SurveyPayload.build(survey, @token) }.compact
    end

    # API timeout debugging
    Rails.logger.info("Survey API request completed for vendor; id: #{@token.vendor.id}")

    render json: { status: 200, count: offers.count, offers: offers }.to_json
  end
  # rubocop:enable Metrics/AbcSize
end
