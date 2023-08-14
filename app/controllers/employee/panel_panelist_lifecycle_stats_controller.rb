# frozen_string_literal: true

class Employee::PanelPanelistLifecycleStatsController < Employee::RecruitmentBaseController
  authorize_resource class: 'Panel'

  def show
    @panel = Panel.find(params[:panel_id])
  end
end
