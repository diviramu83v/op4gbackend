# frozen_string_literal: true

class Employee::FollowupSurveysController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def index
    @survey = Survey.find(params[:survey_id])

    @followups = @survey.onboardings.complete.with_followup_email_address

    respond_to do |format|
      format.html do
        @followups = @followups.page(params[:page]).per(50)
      end
      format.csv do
        send_data @followups.to_followup_csv
      end
    end
  end
end
