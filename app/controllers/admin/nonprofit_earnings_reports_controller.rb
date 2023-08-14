# frozen_string_literal: true

class Admin::NonprofitEarningsReportsController < Admin::BaseController
  def show; end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    @start_year = params['start_year']['start_year']
    @end_year = params['end_year']['end_year']

    @start_month_name = params['start_month']
    @start_month = Date::MONTHNAMES.index(@start_month_name)
    @end_month_name = params['end_month']
    @end_month = Date::MONTHNAMES.index(@end_month_name)

    if @start_year > @end_year || (@start_year == @end_year && @start_month > @end_month)
      flash[:alert] = 'start period can\'t be after end period'
      render :show
      return
    end

    @results = Nonprofit.generate_earnings_report(@start_month, @start_year, @end_month, @end_year)

    if params['generate_csv'].blank?
      render :show
    else
      send_data Nonprofit.build_earnings_csv(@results), filename: 'nonprofit_earnings_report.csv'
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
