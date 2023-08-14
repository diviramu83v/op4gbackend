# frozen_string_literal: true

class Employee::PanelistNonpaymentsController < Employee::MembershipBaseController
  before_action :authenticate_access_to_member_data
  authorize_resource class: 'Panelist'

  def show
    @panelist = Panelist.find(params[:panelist_id])
    @rejected_completions = @panelist.onboardings.complete.nonpayment.most_recent_first
  end
end
