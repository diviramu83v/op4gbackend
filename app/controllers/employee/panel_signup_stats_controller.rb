# frozen_string_literal: true

# this is for the stats page for the Recruitment > Panels > Panel page
class Employee::PanelSignupStatsController < Employee::RecruitmentBaseController
  authorize_resource class: 'Panel'

  def show
    @panel = Panel.find(params[:panel_id])
  end
end
