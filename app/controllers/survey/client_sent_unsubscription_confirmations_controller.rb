# frozen_string_literal: true

class Survey::ClientSentUnsubscriptionConfirmationsController < Survey::BaseController
  def show
    email = params[:email]
    @unsubscription = ClientSentUnsubscription.find_by(email: email)
  end
end
