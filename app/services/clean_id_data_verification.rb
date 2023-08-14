# frozen_string_literal: true

# Verifies that the data provided by CleanID hasn't been tampered with.
class CleanIdDataVerification
  def initialize(data:, onboarding:)
    @data = data.is_a?(String) ? JSON.parse(data) : data # temporary until this has been around for awhile
    @onboarding = onboarding
    @error = ''

    process_data
  end

  def fails_any_checks?
    return false unless @onboarding.run_cleanid_presurvey?

    failed_reason.present?
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def failed_reason
    return 'no data' if data_blank?
    return 'score missing' if score_missing?
    return 'score too high' if score_too_high?
    return 'OR score too high' if or_score_too_high?
    return 'not unique' if unique_failed?
    return 'tampered with transaction id' if tampered_with_transaction_id?
    return 'tampered with data' if tampered_with_data?
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def data_blank?
    @data.blank?
  end

  def process_data
    @score = @data&.dig('Score')
    @or_score = @data&.dig('ORScore')
    @duplicate = @data&.dig('Duplicate')
  end

  def score_missing?
    @error = 'CleanID: score missing' if @score.blank?
    @score.blank?
  end

  def score_too_high?
    @error = 'CleanID: score failed' if @score > 25
    @score > 25
  end

  def or_score_too_high?
    @error = 'CleanID: OR score failed' if @or_score > 25
    @or_score > 25
  end

  def unique_failed?
    @error = 'CleanID: duplicate flag failed' if @duplicate == true
    @duplicate == true
  end

  def tampered_with_transaction_id?
    api_data['message'] == 'Internal server error'
  end

  def tampered_with_data?
    api_data.dig('result', 'Score') != @score || api_data.dig('result', 'ORScore') != @or_score ||
      api_data.dig('result', 'Duplicate') != @duplicate
  end

  def api_data
    @api_data ||= CleanIdApi.new(@data&.dig('TransactionId')).full_set
  end
end
