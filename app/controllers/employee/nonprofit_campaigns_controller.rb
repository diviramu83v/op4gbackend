# frozen_string_literal: true

class Employee::NonprofitCampaignsController < Employee::RecruitmentBaseController
  authorize_resource class: 'RecruitingCampaign'

  def new
    @campaignable = Nonprofit.find(params[:nonprofit_id])
    @campaign = @campaignable.campaigns.new

    render 'employee/recruiting_campaigns/new'
  end

  def create
    @campaignable = Nonprofit.find(params[:nonprofit_id])
    @campaign = @campaignable.campaigns.new(campaign_params)

    if @campaign.save
      redirect_to @campaign
    else
      render 'employee/recruiting_campaigns/new'
    end
  end

  private

  def campaign_params
    params.require(:recruiting_campaign).permit(
      :code, :incentive_flag, :incentive, :campaign_started_at,
      :campaign_stopped_at, :max_signups, :description, :project_zero_flag,
      :source_label, :group_name, :lock_flag
    )
  end
end
