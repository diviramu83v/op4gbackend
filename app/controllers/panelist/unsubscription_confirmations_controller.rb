# frozen_string_literal: true

class Panelist::UnsubscriptionConfirmationsController < ApplicationController
  skip_before_action :authenticate_employee!
  layout 'panelist'

  def show
    email = params[:email]
    @unsubscription = Unsubscription.find_by(email: email)
  end
end
