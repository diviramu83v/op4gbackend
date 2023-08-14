# frozen_string_literal: true

class Employee::CompletesReportsController < Employee::ReportingsBaseController
  authorize_resource class: 'Onboarding'

  def new; end
end
