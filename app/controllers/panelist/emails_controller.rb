# frozen_string_literal: true

class Panelist::EmailsController < Panelist::BaseController
  def edit; end

  def update
    email_params = params.require(:panelist).permit(:email)

    if current_panelist.update(email_params)
      flash[:notice] = 'Account successfully updated.'
      redirect_to edit_account_email_url
    else
      handle_error
    end
  rescue ActiveRecord::RecordNotUnique
    handle_error
  end

  private

  def handle_error
    flash.now[:alert] = 'Account could not be updated.'
    render 'edit'
  end
end
