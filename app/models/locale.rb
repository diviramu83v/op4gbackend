# frozen_string_literal: true

# Languages that our panelists and application use.
# TODO: Convert to ActiveRecord?
class Locale
  NAMES = %w[English French German Spanish Italian].freeze
  SLUGS = %w[en fr de es it].freeze

  ACCOUNT_OPTIONS = NAMES.zip(SLUGS).freeze

  def self.default
    'en'
  end

  def self.recaptcha_session(locale)
    return 'en' if locale.nil?
    return 'en' if locale == 'uk'

    locale
  end
end
