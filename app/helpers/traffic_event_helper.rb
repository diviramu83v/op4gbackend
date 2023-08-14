# frozen_string_literal: true

# View helpers for traffic events.
module TrafficEventHelper
  # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
  def format_message(message)
    case message
    when /^clean_id/
      message.gsub('clean_id', 'CleanID')
    when /^recaptcha/
      message.gsub('recaptcha', 'ReCaptcha')
    when /^gate_survey/
      message.gsub('gate_survey', 'Gate Survey')
    when /^analyze/
      message.gsub('analyze', 'Analyze')
    when /^follow_up/
      message.gsub('follow_up', 'Follow Up')
    when /^record_response/
      message.gsub('record_response', 'Record Response')
    when /^redirect/
      message.gsub('redirect', 'Redirect')
    else
      message
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity

  def format_pre_or_post(pre_or_post)
    "#{pre_or_post.capitalize}-survey"
  end
end
