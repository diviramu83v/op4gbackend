# frozen_string_literal: true

class Survey::OnrampsController < Survey::BaseController
  before_action :set_clicked_if_expert_recruit

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def show
    @onramp = Onramp.find_by(token: params[:token])
    return redirect_to survey_error_url if @onramp.nil?

    @uid = set_uid
    return redirect_to survey_error_url if @uid.blank?

    return redirect_to overquota_url if @onramp.disabled?
    return redirect_to survey_hold_url if @onramp.on_hold?
    return redirect_to survey_error_url unless @onramp.survey_url.present? || current_employee.present?

    begin
      @onboarding = create_onboarding
      @onboarding.add_invitation_if_appropriate
      @onboarding.add_panelist_if_appropriate
      @onboarding.add_panel_if_appropriate

      @onboarding.save_disqo_params(params) if @onramp.disqo?
      @onboarding.save_schlesinger_params(params) if @onramp.schlesinger?
    rescue ActiveRecord::RecordNotUnique
      @onboarding = @onramp.onboardings.find_by(uid: @uid)
    end

    @onboarding.set_security_status

    @onboarding.check_for_ip_change(ip_to_check: @ip)

    @onboarding.affiliate_code = params[:aff_id] if params[:aff_id]
    @onboarding.sub_affiliate_code = params[:aff_sub] if params[:aff_sub]
    @onboarding.save!
    return redirect_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token) if @onboarding.traffic_steps.present?

    redirect_to bad_request_url
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  private

  def set_clicked_if_expert_recruit
    expert_recruit = ExpertRecruit.find_by(token: params[:uid])

    expert_recruit.clicked! if expert_recruit.present?
  end

  def create_onboarding
    bypassed_time = Time.now.utc if @onramp.bypass_token == params[:bypass]
    bypassed_all_time = Time.now.utc if @onramp.bypass_token == params[:bypass_all]
    @onramp.onboardings.create_with(ip_address: @ip, bypassed_security_at: bypassed_time, bypassed_all_at: bypassed_all_time).find_or_create_by(uid: @uid)
  end

  def overquota_url
    if @onramp.vendor_batch.try(:overquota_url).present?
      @onramp.vendor_batch.overquota_url + @uid
    else
      survey_full_url
    end
  end

  def api_param
    return params[:tid] if @onramp.disqo?
    return params[:pid] if @onramp.schlesinger?

    params[:uid]
  end

  def set_uid
    return api_param unless api_param == 'test_link'
    return if current_employee.blank?

    TestUidManager.new(employee: current_employee, onramp: @onramp).next
  end
end
