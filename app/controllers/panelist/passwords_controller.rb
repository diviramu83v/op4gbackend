# frozen_string_literal: true

class Panelist::PasswordsController < Devise::PasswordsController
  layout 'panelist'

  before_action :set_locale

  def create
    super
  rescue StandardError
    flash[:notice] = 'Email service momentarily unavailable; please try again.'
    self.resource = resource_class.new
    render :new
  end

  # PUT /resource/password
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    # Custom conditional added to Devise standard action
    if password_params[:password] != password_params[:confirm_password]
      resource.errors.add(:confirm_password, 'must match password')
      resource.errors.add(:confirm_password, 'password and confirm password do not match')
    end

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)

        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      respond_with resource, location: after_resetting_password_path_for(resource)
    else
      set_minimum_password_length
      respond_with resource
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity

  def password_params
    params.require(:panelist).permit(:password, :confirm_password)
  end
end
