# frozen_string_literal: true

class Employee::AffiliateReportsController < Employee::RecruitmentBaseController
  authorize_resource class: 'Panel'

  def show
    @period = validate_and_set_time_period
  end

  private

  def validate_and_set_time_period
    if period_params.present? && period_params[:end_period] < period_params[:start_period]
      flash.now.alert = 'Start period can\'t be after end period'
      @period = default_period
      render :show
      return
    end
    @period = period_params || default_period
  end

  def period_params
    params.require(:period_selector).permit(:start_period, :end_period) if params[:period_selector].present?
  end

  def default_period
    { start_period: PeriodCalculator.monthly_periods.first.last.to_s, end_period: PeriodCalculator.monthly_periods.first.last.to_s }
  end
end
