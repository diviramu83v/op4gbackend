# frozen_string_literal: true

class Panelist::PrivateController < Panelist::BaseController
  def edit; end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    unless current_panelist.valid_password?(private_params[:current_password])
      flash[:alert] = 'Current password does not match'
      return render 'edit'
    end

    current_panelist.password = private_params[:new_password]

    unless current_panelist.password == private_params[:password_confirmation]
      flash[:alert] = '"New Password" and "Password Confirmation" must match'
      return render 'edit'
    end

    unless current_panelist.password.length >= 8
      flash.now[:alert] = 'Password must be at least 8 characters'
      return render 'edit'
    end

    # TODO: use Devise validation instead?
    flash[:notice] = 'Password successfully updated' if current_panelist.save
    bypass_sign_in(current_panelist)

    redirect_to edit_account_private_url
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def private_params
    params.require(:panelist).permit(:current_password, :new_password, :password_confirmation)
  end
end
