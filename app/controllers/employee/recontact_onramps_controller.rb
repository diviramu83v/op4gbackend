# frozen_string_literal: true

class Employee::RecontactOnrampsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def show
    @recontact = Survey.find(params[:recontact_id])
    @project = @recontact.project
  end
end
