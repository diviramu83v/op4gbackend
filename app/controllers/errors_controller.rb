# frozen_string_literal: true

class ErrorsController < ApplicationController
  protect_from_forgery with: :null_session

  layout 'application'

  def bad_request
    respond_to do |format|
      format.html { render status: :bad_request }
      format.all { head :bad_request }
    end
  end

  def not_found
    logger.info "Not Found: URL:#{request.original_url}"

    return handle_spam if SpamDetector.looks_fraudulent?(request: request)

    respond_to do |format|
      format.html { render status: :not_found }
      format.all { head :not_found }
    end
  end

  def unprocessable_entity
    render status: :unprocessable_entity
  end

  def internal_server_error
    render status: :internal_server_error
  end

  private

  def handle_spam
    IpAddress.auto_block(address: request.remote_ip, reason: 'Spam')
    redirect_to bad_request_url
  end
end
