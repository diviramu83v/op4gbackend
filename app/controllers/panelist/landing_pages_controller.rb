# frozen_string_literal: true

class Panelist::LandingPagesController < Panelist::PublicController
  include LandingPageParameterHandling

  before_action :redirect_to_dashboard_if_signed_in

  def show # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    store_landing_parameters

    @panel = Panel.find_by(slug: params[:panel])
    @incentive = @panel&.incentive || 2

    @campaign = RecruitingCampaign.active.find_by(code: params[:code])
    @incentive = @campaign.incentive if @campaign&.incentive.present?

    if @campaign.present? && @campaign.campaignable.present?
      @nonprofit = @campaign.campaignable
      session[:nonprofit_id] = @nonprofit.id

      return render 'nonprofit'
    end

    # Op4G gets default page.
    return render 'default' if @panel.try(:slug) == 'op4g-us'

    # Panel-specific page if a different panel found.
    return render :show if @panel.present?

    render 'default'
  end
end
