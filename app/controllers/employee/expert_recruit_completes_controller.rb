# frozen_string_literal: true

class Employee::ExpertRecruitCompletesController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def show
    @survey = Survey.find(params[:survey_id])
    @completes = @survey.onboardings.complete.expert_recruit

    respond_to do |format|
      format.html
      format.csv do
        send_data @completes.to_completes_csv, filename: "#{@survey.project.name}-#{@survey.name}-expert-recruit-complete-list.csv"
      end
    end
  end
end
