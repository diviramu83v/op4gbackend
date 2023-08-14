# frozen_string_literal: true

class Panelist::FacebookDeauthorizationController < Panelist::BaseController
  # rubocop:disable Metrics/MethodLength
  def create
    remove_facebook_params = {
      facebook_authorized: nil,
      facebook_image: nil,
      provider: nil,
      facebook_uid: nil
    }

    if current_panelist.update(remove_facebook_params)
      flash[:notice] = 'Facebook data removed.'
    else
      flash.now[:alert] = 'Facebook data could not be removed - please try again.'
    end

    redirect_to edit_account_email_url
  end
  # rubocop:enable Metrics/MethodLength
end
