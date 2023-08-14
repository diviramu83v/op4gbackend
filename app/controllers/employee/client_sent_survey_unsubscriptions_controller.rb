# frozen_string_literal: true

class Employee::ClientSentSurveyUnsubscriptionsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def show
    @survey = Survey.find(params[:survey_id])
    @unsubscriptions = ClientSentUnsubscription.order(created_at: :desc)

    respond_to do |format|
      format.html
      format.csv do
        send_data @unsubscriptions.to_csv, filename: 'client-sent-unsubscribed-list.csv'
      end
    end
  end
end
