# frozen_string_literal: true

class Employee::SchlesingerQuotaActivationsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def create
    @schlesinger_quota = SchlesingerQuota.find(params[:schlesinger_quota_id])
    @schlesinger_quota.update_quota_status(status: 'live')

    redirect_to survey_schlesinger_quotas_url(@schlesinger_quota.survey)
  end

  def destroy
    @schlesinger_quota = SchlesingerQuota.find(params[:id])
    @schlesinger_quota.update_quota_status(status: 'paused')

    redirect_to survey_schlesinger_quotas_url(@schlesinger_quota.survey)
  end
end
