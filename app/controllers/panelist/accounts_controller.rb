# frozen_string_literal: true

class Panelist::AccountsController < Panelist::BaseController
  def show
    redirect_to account_payments_url
  end

  def destroy
    panelist = current_panelist
    sign_out(panelist) && panelist.soft_delete!

    flash[:notice] = 'Account successfully deleted.'
    redirect_to new_panelist_session_url
  end
end
