# frozen_string_literal: true

class Employee::SuspensionsController < Employee::MembershipBaseController
  authorize_resource class: 'Panelist'

  def create
    @panelist = Panelist.find(params[:panelist_id])

    @panelist.suspend

    redirect_to @panelist, notice: 'Panelist successfully suspended.'
  end

  def destroy
    @panelist = Panelist.find(params[:panelist_id])

    @panelist.unsuspend

    redirect_to @panelist, notice: 'Panelist successfully unsuspended.'
  end
end
