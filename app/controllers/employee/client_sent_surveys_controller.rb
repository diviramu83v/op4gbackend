# frozen_string_literal: true

class Employee::ClientSentSurveysController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  before_action :load_survey, only: [:index, :new, :create]

  def index
    @client_sent_survey = @survey.client_sent_survey
  end

  def new
    @client_sent_survey = @survey.build_client_sent_survey
  end

  def edit
    @client_sent_survey = ClientSentSurvey.find(params[:id])
    @survey = @client_sent_survey.survey
  end

  def create
    @client_sent_survey = @survey.create_client_sent_survey(client_sent_survey_params)

    if @client_sent_survey.save
      flash[:notice] = 'Client sent survey saved successfully.'
      redirect_to survey_client_sent_surveys_url(@survey)
    else
      render 'new'
    end
  end

  def update
    @client_sent_survey = ClientSentSurvey.find(params[:id])
    @survey = @client_sent_survey.survey

    if @client_sent_survey.update(client_sent_survey_params)
      flash[:notice] = 'Client sent survey updated successfully.'
      redirect_to survey_client_sent_surveys_url(@survey)
    else
      render 'edit'
    end
  end

  private

  def client_sent_survey_params
    params.require(:client_sent_survey).permit(:employee_id, :description, :email_subject, :landing_page_text, :incentive)
  end

  def load_survey
    @survey = Survey.find(params[:survey_id])
  end
end
