# frozen_string_literal: true

class Employee::PanelistsController < Employee::MembershipBaseController
  authorize_resource

  def index
    if params[:term].present?
      @panelists = Panelist.search(params[:term]).most_recent_first
      @search_term = params[:term]
    else
      @panelists = Panelist.active.most_recent_first.page(params[:page])
    end
  end

  def show
    @panelist = Panelist.find(params[:id])

    # This will re-calculate the panelist's score to ensure an accurate number.
    PanelistScoreCalculator.new(panelist: @panelist).calculate!

    @invitations = @panelist.invitations.has_been_sent.most_recently_sent_first.page(params[:page])
    flash[:notice] = 'This panelist has a blocked IP address.' if @panelist.current_ip_blocked?
  end

  def edit
    @panelist = Panelist.find(params[:id])
  end

  def update
    @panelist = Panelist.find(params[:id])
    if @panelist.update(panelist_params)
      flash[:notice] = 'Panelist successfully updated'
      redirect_to edit_panelist_url(@panelist)
    else
      flash[:notice] = 'Panelist could not be updated'
      render 'edit'
    end
  end

  private

  def panelist_params
    params.require(:panelist).permit(:first_name, :last_name, :email, :address, :city, :state, :postal_code, :verified_flag)
  end
end
