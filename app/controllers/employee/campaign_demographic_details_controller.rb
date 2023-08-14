# frozen_string_literal: true

class Employee::CampaignDemographicDetailsController < Employee::RecruitmentBaseController
  authorize_resource class: 'RecruitingCampaign'

  def show
    @campaign = RecruitingCampaign.find(params[:recruiting_campaign_id])

    respond_to do |format|
      format.html
      format.csv do
        filename = "recruiting-campaign-#{@campaign.id}-panelist-demographic-details.csv"

        send_data @campaign.to_csv, filename: filename
      end
    end
  end
end
