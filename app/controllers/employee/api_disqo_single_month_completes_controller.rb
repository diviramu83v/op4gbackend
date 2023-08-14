# frozen_string_literal: true

class Employee::ApiDisqoSingleMonthCompletesController < Employee::SupplyBaseController
  skip_authorization_check

  def index
    @date = DateTime.parse(params[:date])
    starting = @date.beginning_of_month
    ending = @date.end_of_month
    @disqo_completes_grouped = Onboarding.complete.for_disqo.where('onboardings.created_at BETWEEN ? AND ?', starting, ending).group('onramps.id').count
  end
end
