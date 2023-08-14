# frozen_string_literal: true

class Employee::ApiCintSurveysController < Employee::SupplyBaseController
  skip_authorization_check

  def index
    store_survey_filters(params)
    @cint_surveys = cint_surveys_for_status(session[:cint_survey_status]).page(params[:page]).per(25)
  end

  private

  def store_survey_filters(params)
    session[:cint_survey_status] = 'all' if params[:status].blank?
    session[:cint_survey_status] = params[:status] if params[:status].present?
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def cint_surveys_for_status(status)
    case status
    when 'all' then CintSurvey.all
    when 'draft' then CintSurvey.draft
    when 'live' then CintSurvey.live
    when 'paused' then CintSurvey.paused
    when 'halted' then CintSurvey.halted
    when 'complete' then CintSurvey.complete
    when 'closed' then CintSurvey.closed
    when 'activation_failed' then CintSurvey.activation_failed
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
end
