# frozen_string_literal: true

class Panelist::ContributionsController < Panelist::BaseController
  def show
    @nonprofit = current_panelist.nonprofit
    @nonprofits = Nonprofit.all
  end

  def update
    if current_panelist.lock_flag?
      redirect_to panelist_dashboard_path
    else
      current_panelist.update!(donation_percentage: contribution_params[:contribution])
      redirect_to account_contribution_path
    end
  end

  private

  def contribution_params
    params.require(:contribution_percent).permit(:contribution)
  end
end
