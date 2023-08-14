# frozen_string_literal: true

class Employee::BlockReasonsReportsController < Employee::ReportingsBaseController
  authorize_resource class: 'Onboarding'

  def new; end
end
