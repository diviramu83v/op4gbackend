# frozen_string_literal: true

class Employee::PanelistDemographicsController < Employee::MembershipBaseController
  before_action :authenticate_access_to_member_data
  authorize_resource class: 'Panelist'

  def show
    @panelist = Panelist.find(params[:panelist_id])
  end
end
