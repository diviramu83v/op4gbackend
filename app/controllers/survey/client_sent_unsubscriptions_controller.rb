# frozen_string_literal: true

class Survey::ClientSentUnsubscriptionsController < Survey::BaseController
  before_action :load_params

  def show
    @client_sent_survey_invitation = ClientSentSurveyInvitation.find_by(email: @email, unsubscribe_token: @unsubscribe_token)
    @unsubscription = ClientSentUnsubscription.find_by(client_sent_survey_invitation: @client_sent_survey_invitation)
  end

  def create
    client_sent_survey_invitation = ClientSentSurveyInvitation.find_by(email: @email, unsubscribe_token: @unsubscribe_token)
    ClientSentUnsubscription.create!(email: @email, client_sent_survey_invitation: client_sent_survey_invitation)

    redirect_to survey_client_sent_unsubscribe_confirmation_url(email: @email)
  end

  private

  def load_params
    @email = params[:email]
    @unsubscribe_token = params[:unsubscribe_token]
  end
end
