# frozen_string_literal: true

class Employee::BlockRateBySourcesController < Employee::ReportingsBaseController
  authorize_resource class: 'Project'

  def new
    @onboardings = blocked_onboardings_from_time_period('start_time', 'end_time')
  end

  def get_blocked_sources
    if params[:start_date].present? && params[:end_date].present?
      start_time = params[:start_date].to_datetime.strftime('%Y/%m/%d')
      end_time = params[:end_date].to_datetime.strftime('%Y/%m/%d')
      @onboardings = blocked_onboardings_from_time_period(start_time, end_time)
    else
      @onboardings = []
    end
  end

  private

  def blocked_onboardings_from_time_period(start_time, end_time)
    data = []
    onboardings = Onboarding.blocked.where(created_at: start_time..end_time).includes([:api_vendor, :batch_vendor, :cint_survey, :disqo_quota, onramp: :panel, survey: :disqo_quotas])
    onboardings.each do |onboarding|
      source_name = onboarding.source_name
      if source_name&.include?('Disqo')
        data << 'Disqo'
      elsif source_name&.include?('Cint')
        data << 'Cint'
      else
        data << source_name
      end
    end
    data.uniq
  end
end
