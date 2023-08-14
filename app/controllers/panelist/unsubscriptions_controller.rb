# frozen_string_literal: true

class Panelist::UnsubscriptionsController < ApplicationController
  skip_before_action :authenticate_employee!
  before_action :load_email
  layout 'panelist'

  def show
    @unsubscription = Unsubscription.find_by(email: @email)
    @panelist = Panelist.find_by(email: @email)
    @unsubscribe_token = params[:token]
    @invitation = ProjectInvitation.find_by(token: @unsubscribe_token)
  end

  def create
    @panelist = Panelist.find_by(email: @email)

    render 'errors/not_found' if @panelist.nil?

    Unsubscription.create!(email: @email, panelist: @panelist)

    redirect_to unsubscribe_confirmation_url(email: @email)
  end

  private

  def load_email
    @email = params[:email]
  end
end
