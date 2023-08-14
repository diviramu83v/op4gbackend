# frozen_string_literal: true

class Employee::RecruitingCampaignsController < Employee::RecruitmentBaseController
  authorize_resource

  def index
    @campaigns = RecruitingCampaign.where(campaignable: nil)
    @campaigns = @campaigns.page(params[:page]).per(50)
  end

  def show
    @campaign = RecruitingCampaign.find(params[:id])
  end

  def new
    @campaign = RecruitingCampaign.new
  end

  def edit
    @campaign = RecruitingCampaign.find(params[:id])
  end

  def create
    @campaign = RecruitingCampaign.new(campaign_params)

    flash[:alert] = 'Unable to save campaign.' unless @campaign.save

    redirect_to @campaign
  end

  def update
    @campaign = RecruitingCampaign.find(params[:id])

    if @campaign.update(campaign_params)
      redirect_to @campaign, notice: 'Successfully updated campaign.'
    else
      render 'new'
    end
  end

  private

  def campaign_params
    params.require(:recruiting_campaign).permit(
      :code, :incentive_flag, :incentive, :campaign_started_at,
      :campaign_stopped_at, :max_signups, :description, :project_zero_flag,
      :source_label, :group_name, :lock_flag, :business_name_flag
    )
  end
end
