# frozen_string_literal: true

class Employee::DisqoRejectedTrafficReportsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def index; end
end
