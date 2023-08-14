# frozen_string_literal: true

class Survey::BaseController < ApplicationController
  skip_before_action :authenticate_employee!

  before_action :log_blocked_ip

  layout 'survey'

  class OnboardingTokenError < StandardError; end

  rescue_from OnboardingTokenError do
    logger.info "WATCHING: IP blocking: OnboardingTokenError from IP #{@ip.address}"
    redirect_to bad_request_url
  end

  private

  def load_onboarding_from_onboarding_token_param
    @onboarding = Onboarding.find_by(onboarding_token: params[:onboarding_token])

    raise OnboardingTokenError, "#{self.class}/#{action_name}: no traffic record for token: #{params[:onboarding_token]}" if @onboarding.nil?
  end

  def check_onboarding_ip
    @onboarding.check_for_ip_change(ip_to_check: @ip)
  end

  def log_blocked_ip
    return unless @ip.blocked?

    logger.info "WATCHING: IP blocking: allowing traffic from blocked IP: #{@ip.address}"
  end
end
