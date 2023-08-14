# frozen_string_literal: true

class Employee::PanelistEmailListsController < Employee::RecruitmentBaseController
  authorize_resource class: 'Panelist'
  protect_from_forgery except: :show

  def show
    @panel = Panel.find(params[:panel_id])
  end
end
