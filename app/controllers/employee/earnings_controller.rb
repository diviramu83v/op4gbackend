# frozen_string_literal: true

class Employee::EarningsController < Employee::OperationsBaseController
  authorize_resource

  def index
    @survey = Survey.find(params[:survey_id])
    @earnings = @survey.earnings
  end

  def new
    @survey = Survey.find(params[:survey_id])
    @earnings_batch = EarningsBatch.new
  end

  def create
    @survey = Survey.find(params[:survey_id])
    @earnings_batch = EarningsBatch.new(batch_params)

    @earnings_batch.survey = @survey

    raw_id_count = @earnings_batch.raw_id_count

    if @earnings_batch.save
      flash[:alert] = 'Unable to match all IDs.' if @earnings_batch.earnings.count != raw_id_count
      redirect_to survey_earnings_url(@survey)
    else
      render 'new'
    end
  end

  def destroy
    survey = Survey.find(params[:survey_id])
    survey.earnings.find_each(&:destroy)
    redirect_to survey_earnings_url(survey)
  end

  private

  def batch_params
    params.require(:earnings_batch).permit(:amount, :ids).merge(employee: current_employee)
  end
end
