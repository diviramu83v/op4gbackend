# frozen_string_literal: true

require 'singleton'

# Wrapper class for the MadMimi API plugin
class MadMimiMailer
  require 'madmimi'
  include Singleton

  def initialize
    @mimi = MadMimi.new(ENV.fetch('MIMI_USERNAME', nil), ENV.fetch('MIMI_MAILER_API_KEY', nil), verify_ssl: true)
  end

  attr_reader :result

  def send(options, body)
    @mimi.send_mail(options, body)
  rescue EOFError
    Rails.logger.error("end of file error. options:#{options}, body:#{body}")
    false
  end

  def successful?(send_result)
    send_result.present? && send_result.start_with?('s-')
  end

  def allow_real_emails?
    ENV['SEND_EMAIL_FOR_REAL'] == 'yes'
  end
end
