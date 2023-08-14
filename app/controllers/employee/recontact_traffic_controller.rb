# frozen_string_literal: true

class Employee::RecontactTrafficController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def show
    @recontact = Survey.find(params[:recontact_id])
  end
end
