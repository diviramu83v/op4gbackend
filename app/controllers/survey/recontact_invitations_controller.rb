# frozen_string_literal: true

class Survey::RecontactInvitationsController < Survey::BaseController
  # rubocop:disable Metrics/AbcSize
  def show
    @recontact_invitation = RecontactInvitation.find_by(token: params[:token])
    return redirect_to survey_recontact_invitation_errors_url, alert: 'Survey error. Please try again.' if @recontact_invitation.nil?

    @recontact_invitation.clicked!

    @survey = @recontact_invitation.survey
    return redirect_to survey_recontact_invitation_errors_url, alert: 'Survey error. Please try again.' if @survey.nil?

    @onramp = @survey.onramp_for_recontact(@survey)
    return redirect_to survey_recontact_invitation_errors_url, alert: 'Survey error. Please try again.' if @onramp.nil?

    redirect_to survey_onramp_url(@onramp.token, uid: @recontact_invitation.token)
  end
  # rubocop:enable Metrics/AbcSize
end
