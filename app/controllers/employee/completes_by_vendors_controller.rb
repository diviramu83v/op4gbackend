# frozen_string_literal: true

class Employee::CompletesByVendorsController < Employee::ReportingsBaseController
  authorize_resource class: 'Project'

  def new; end
end
