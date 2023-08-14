# frozen_string_literal: true

class Employee::SurveyAdjustmentsController < Employee::OperationsBaseController
  authorize_resource class: 'SurveyAdjustment'
  before_action :assign_survey

  def new
    @adjustment = @survey.adjustments.new
    save_return_url
  end

  def create
    @adjustment = @survey.adjustments.new(adjustment_params)

    if @adjustment.save
      flash[:notice] = "Complete count adjusted by #{@adjustment.offset}."
      redirect_to use_return_url(default_url: survey_url(@survey))
    else
      render :new
    end
  end

  private

  def assign_survey
    @survey = Survey.find(params[:survey_id])
  end

  def adjustment_params
    params.require(:survey_adjustment).permit(:client_count)
  end

  def save_return_url
    session[:return_url] = params[:return_url] if params[:return_url].present?
  end

  def use_return_url(default_url:)
    url = session[:return_url].presence || default_url
    session.delete(:return_url)
    url
  end
end
