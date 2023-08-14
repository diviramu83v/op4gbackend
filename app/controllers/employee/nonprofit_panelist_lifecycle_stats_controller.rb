# frozen_string_literal: true

class Employee::NonprofitPanelistLifecycleStatsController < Employee::RecruitmentBaseController
  authorize_resource class: 'Nonprofit'

  def show
    @nonprofit = Nonprofit.find(params[:nonprofit_id])
  end
end
