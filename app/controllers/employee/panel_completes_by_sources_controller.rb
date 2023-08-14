# frozen_string_literal: true

class Employee::PanelCompletesBySourcesController < Employee::ReportingsBaseController
  authorize_resource class: 'Project'

  def new; end
end
