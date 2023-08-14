# frozen_string_literal: true

class Panelist::InvitationsController < Panelist::BaseController
  # Panelists starting a survey hit this endpoint.
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def show
    @panelist = current_panelist
    @panelist.record_activity

    @invitation = ProjectInvitation.find_by(token: params[:token])
    return redirect_to panelist_dashboard_url, alert: 'Survey error. Please try again.' if @invitation.nil?

    # return redirect_to panelist_dashboard_url, alert: 'Survey error. Please try again.' unless @invitation.sent?
    if @invitation.closed?
      flash[:notice] = 'This survey has been closed. Thanks for your interest!'
      return redirect_to panelist_dashboard_url
    end

    @invitation.clicked!

    @survey = @invitation.try(:survey)
    return redirect_to panelist_dashboard_url, alert: 'Survey error. Please try again.' if @survey.nil?
    return redirect_to panelist_dashboard_url unless current_panelist.invited_and_open?(survey: @survey)

    @onramp = @survey.onramp_for_panel(@invitation.panel)
    return redirect_to panelist_dashboard_url, alert: 'Survey error. Please try again.' if @onramp.nil?

    redirect_to survey_onramp_url(@onramp.token, uid: @invitation.token)
  rescue SurveyInvitationStatusError => e
    logger.info "WATCHING: Error caught: SurveyInvitationStatusError: #{e.message}"
    redirect_to panelist_dashboard_url, notice: 'Sorry, there was a problem starting this survey. Did you already take or dismiss this one?'
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def destroy
    invitation = ProjectInvitation.find(params[:id])
    if invitation.declined!
      flash[:notice] = 'Survey has been dismissed.'
    else
      flash[:alert] = 'Unable to dismiss survey.'
    end
    redirect_to panelist_dashboard_url
  rescue SurveyInvitationStatusError => e
    logger.info "WATCHING: Error caught: SurveyInvitationStatusError: #{e.message}"
    redirect_to panelist_dashboard_url, notice: 'Sorry, there was a problem dismissing this survey. Did you already take or dismiss this one?'
  end
end
