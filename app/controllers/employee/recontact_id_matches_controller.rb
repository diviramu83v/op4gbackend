# frozen_string_literal: true

class Employee::RecontactIdMatchesController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def show
    @recontact = Survey.find(params[:recontact_id])
    @project = @recontact.project

    respond_to do |format|
      format.html
      format.csv do
        filename = "#{@recontact.name.parameterize}-id-matches.csv"

        send_data @recontact.to_csv, filename: filename
      end
    end
  end
end
