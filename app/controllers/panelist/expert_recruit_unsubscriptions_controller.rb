# frozen_string_literal: true

class Panelist::ExpertRecruitUnsubscriptionsController < ApplicationController
  skip_before_action :authenticate_employee!
  before_action :load_params
  layout 'panelist'

  def show
    @expert_recruit = ExpertRecruit.find_by(email: @email, unsubscribe_token: @unsubscribe_token)
    @unsubscription = ExpertRecruitUnsubscription.find_by(expert_recruit: @expert_recruit)
  end

  def create
    expert_recruit = ExpertRecruit.find_by(email: @email, unsubscribe_token: @unsubscribe_token)
    ExpertRecruitUnsubscription.create!(email: @email, expert_recruit: expert_recruit)

    redirect_to expert_unsubscribe_confirmation_url(email: @email)
  end

  private

  def load_params
    @email = params[:email]
    @unsubscribe_token = params[:unsubscribe_token]
  end
end
