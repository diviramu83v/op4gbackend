# frozen_string_literal: true

# this is for the stats page for the Recruitment > Campaigns > Campaign page
class Employee::CampaignSignupStatsController < Employee::RecruitmentBaseController
  authorize_resource class: 'RecruitingCampaign'

  def show
    @campaign = RecruitingCampaign.find(params[:recruiting_campaign_id])
  end
end
