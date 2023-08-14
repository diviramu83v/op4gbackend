# frozen_string_literal: true

class Employee::CampaignPanelistLifecycleStatsController < Employee::RecruitmentBaseController
  authorize_resource class: 'RecruitingCampaign'

  def show
    @campaign = RecruitingCampaign.find(params[:recruiting_campaign_id])
  end
end
