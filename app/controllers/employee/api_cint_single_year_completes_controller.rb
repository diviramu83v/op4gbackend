# frozen_string_literal: true

class Employee::ApiCintSingleYearCompletesController < Employee::SupplyBaseController
  skip_authorization_check

  def index
    @year = params[:year]
    start_date = Time.zone.local(@year).beginning_of_year
    end_date = Time.zone.local(@year).end_of_year
    start_date = "#{start_date.strftime('%Y-%m-%d')} 00:00:00"
    end_date = "#{end_date.strftime('%Y-%m-%d')} 23:59:59"
    onboardings = Onboarding.complete.for_cint.where('onboardings.created_at BETWEEN ? AND ?', start_date, end_date)
    @onboarding_ids = onboardings.pluck(:id)
  end
end
