# frozen_string_literal: true

class Survey::ClientSentSurveyInvitationsController < Survey::BaseController
  before_action :set_onramp, only: [:create]

  def index; end

  def create
    @client_sent_survey_invitation = @onramp.client_sent_survey_invitations.new(client_sent_survey_invitation_params)

    if @client_sent_survey_invitation.save
      redirect_to survey_client_sent_survey_invitations_url
    else
      flash.now[:alert] = 'Please enter a valid email address.'
      render 'survey/client_sent_surveys/show', token: @onramp.token
    end
  end

  private

  def set_onramp
    @onramp = Onramp.find(params[:survey_client_sent_survey_invitation][:onramp_id])
  end

  def client_sent_survey_invitation_params
    params.require(:survey_client_sent_survey_invitation).permit(:email, :opt_in, :onramp_id, :status, :clicked_at)
  end
end
