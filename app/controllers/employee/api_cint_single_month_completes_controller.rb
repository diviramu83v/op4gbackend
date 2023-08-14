# frozen_string_literal: true

class Employee::ApiCintSingleMonthCompletesController < Employee::SupplyBaseController
  skip_authorization_check

  def index
    @date = DateTime.parse(params[:date])
    @cint_completes_grouped = Onboarding.complete.for_cint.for_month(@date).group('onramps.id').count
  end
end
