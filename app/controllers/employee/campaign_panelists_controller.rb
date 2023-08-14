# frozen_string_literal: true

class Employee::CampaignPanelistsController < Employee::RecruitmentBaseController
  authorize_resource class: 'RecruitingCampaign'

  def index
    @campaign = RecruitingCampaign.find(params[:recruiting_campaign_id])
    @panelists = @campaign.panelists

    respond_to do |format|
      format.html
      format.csv do
        generate_panelists_csv(@panelists)
      end
    end
  end
end
