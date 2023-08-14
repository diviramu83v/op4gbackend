# frozen_string_literal: true

class Employee::AffiliatePanelistLifecycleStatsController < Employee::RecruitmentBaseController
  authorize_resource class: 'Affiliate'

  def show
    @affiliate = Affiliate.find(params[:affiliate_id])
  end
end
