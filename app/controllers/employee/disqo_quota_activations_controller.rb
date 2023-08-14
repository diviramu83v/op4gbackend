# frozen_string_literal: true

class Employee::DisqoQuotaActivationsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def create
    @disqo_quota = DisqoQuota.find(params[:disqo_quota_id])
    @disqo_quota.update_quota_status(status: 'LIVE')
    @disqo_quota.update_project_status(status: 'OPEN')

    redirect_to survey_disqo_quotas_url(@disqo_quota.survey)
  end

  def destroy
    @disqo_quota = DisqoQuota.find(params[:id])
    @disqo_quota.update_quota_status(status: 'PAUSED')
    @disqo_quota.update_project_status(status: 'HOLD')

    redirect_to survey_disqo_quotas_url(@disqo_quota.survey)
  end
end
