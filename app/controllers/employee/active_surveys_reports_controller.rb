# frozen_string_literal: true

class Employee::ActiveSurveysReportsController < Employee::ReportingsBaseController
  authorize_resource class: 'Survey'

  def new; end
end
