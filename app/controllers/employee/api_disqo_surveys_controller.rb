# frozen_string_literal: true

class Employee::ApiDisqoSurveysController < Employee::SupplyBaseController
  skip_authorization_check

  def index
    store_disqo_filters(params)
    @disqo_quotas = disqos_for_status(session[:disqo_status]).order(created_at: :desc).page(params[:page]).per(25)
  end

  private

  def store_disqo_filters(params)
    session[:disqo_status] = 'all' if params[:status].blank?
    session[:disqo_status] = params[:status] if params[:status].present?
  end

  def disqos_for_status(status)
    case status
    when 'all' then DisqoQuota.all
    when 'live' then DisqoQuota.live
    end
  end
end
