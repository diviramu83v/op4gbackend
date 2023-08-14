# frozen_string_literal: true

# Handles feature flags
class SpamDetector
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def self.looks_fraudulent?(request:)
    return true if request.fullpath == '/password'
    return true if request.fullpath == '/followups'
    return true if request.fullpath == '/1'
    return true if request.fullpath == '/https://survey.op4g.com/'

    return true if request.fullpath.start_with? '/status?'
    return true if request.fullpath.start_with? '/completed?'
    return true if request.fullpath.end_with? '.js'

    return true if request.fullpath.include? 'ads.txt'
    return true if request.fullpath.include? 'favicon'
    return true if request.fullpath.include? 'survey.ico'

    false
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
end
