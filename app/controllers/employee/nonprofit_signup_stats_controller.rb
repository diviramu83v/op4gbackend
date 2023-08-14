# frozen_string_literal: true

# this is for the stats page for the Recruitment > Nonprofits > Nonprofit page
class Employee::NonprofitSignupStatsController < Employee::RecruitmentBaseController
  authorize_resource class: 'Nonprofit'

  def show
    @nonprofit = Nonprofit.find(params[:nonprofit_id])
  end
end
