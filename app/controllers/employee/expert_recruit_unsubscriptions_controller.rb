# frozen_string_literal: true

class Employee::ExpertRecruitUnsubscriptionsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def show
    @survey = Survey.find(params[:survey_id])
    @unsubscriptions = ExpertRecruitUnsubscription.order(created_at: :desc)

    respond_to do |format|
      format.html
      format.csv do
        send_data @unsubscriptions.to_csv, filename: 'expert-recruit-unsubscribed-list.csv'
      end
    end
  end
end
