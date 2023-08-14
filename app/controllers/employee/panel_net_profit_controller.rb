# frozen_string_literal: true

class Employee::PanelNetProfitController < Employee::RecruitmentBaseController
  authorize_resource class: 'Panel'

  def show
    @panel = Panel.find(params[:panel_id])
  end
end
