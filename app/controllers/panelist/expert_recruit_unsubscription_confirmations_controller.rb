# frozen_string_literal: true

class Panelist::ExpertRecruitUnsubscriptionConfirmationsController < ApplicationController
  skip_before_action :authenticate_employee!
  layout 'panelist'

  def show
    email = params[:email]
    @unsubscription = ExpertRecruitUnsubscription.find_by(email: email)
  end
end
