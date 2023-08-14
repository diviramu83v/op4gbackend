# frozen_string_literal: true

class Employee::PanelistPaymentsController < Employee::MembershipBaseController
  before_action :authenticate_access_to_member_data
  authorize_resource class: 'Panelist'

  def show
    @panelist = Panelist.find(params[:panelist_id])
    @years = @panelist.active_financial_period_years
    @details_present = @years.any? || @panelist.legacy_earnings.positive?
  end
end
