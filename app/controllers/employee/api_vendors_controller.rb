# frozen_string_literal: true

class Employee::ApiVendorsController < Employee::SupplyBaseController
  authorize_resource class: 'SurveyApiTarget'

  def index
    @vendors = ApiToken.active_vendors
    @surveys = Survey.live.available_on_api.page(params[:page])
  end

  def show
    @vendor = Vendor.find(params[:id])
    store_project_filters(params)
    @surveys = surveys_for_status(session[:vendor_status])
  end

  private

  def store_project_filters(params)
    session[:vendor_status] = 'all' if params[:status].blank?
    session[:vendor_status] = params[:status] if params[:status].present?
  end

  def surveys_for_status(status)
    case status
    when 'all' then @vendor.api_surveys.available_on_api
    when 'live' then @vendor.api_surveys.live.available_on_api
    when 'finished' then @vendor.api_surveys.finished.available_on_api
    when 'hold' then @vendor.api_surveys.hold.available_on_api
    end
  end
end
