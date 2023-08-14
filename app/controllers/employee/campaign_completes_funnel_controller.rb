# frozen_string_literal: true

class Employee::CampaignCompletesFunnelController < Employee::RecruitmentBaseController
  authorize_resource class: 'RecruitingCampaign'

  def show
    @campaign = RecruitingCampaign.find(params[:recruiting_campaign_id])
  end
end
