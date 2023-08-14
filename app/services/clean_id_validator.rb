# frozen_string_literal: true

# Checks whether a panelist's CleanID data has failed.
class CleanIdValidator
  def initialize(clean_id_data)
    @data = format_clean_id(clean_id_data)
    @score = extract_score
    @or_score = extract_or_score
    @duplicate = extract_duplicate
  end

  def failed? # rubocop:disable Metrics/CyclomaticComplexity
    @data.blank? || @score.blank? || @or_score.blank? || @score > 25 || @or_score > 25 || @duplicate.nil? || @duplicate == true || data_tampered?
  end

  private

  def format_clean_id(data)
    data.is_a?(String) ? {} : data
  end

  def extract_score
    @data&.dig('Score')
  end

  def extract_or_score
    @data&.dig('ORScore')
  end

  def extract_duplicate
    @data&.dig('Duplicate')
  end

  def data_tampered?
    api_data.dig('result', 'Score') != @score || api_data.dig('result', 'ORScore') != @or_score ||
      api_data.dig('result', 'Duplicate') != @duplicate
  end

  def api_data
    @api_data ||= CleanIdApi.new(@data&.dig('TransactionId')).full_set
  end
end
