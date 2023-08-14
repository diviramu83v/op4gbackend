# frozen_string_literal: true

# this is for the stats page for the Recruitment > Affiliates > Affiliate page
class Employee::AffiliateSignupStatsController < Employee::RecruitmentBaseController
  authorize_resource class: 'Affiliate'

  def show
    @affiliate = Affiliate.find(params[:affiliate_id])
  end
end
