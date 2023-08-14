# frozen_string_literal: true

# Get completes funnel data
class CompletesFunnelChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug 'Subscribed to the completes funnel channel.'
    resource = set_resource
    stream_for resource
    PullCompletesFunnelDataJob.perform_later(resource, params[:year], params[:month])
  end

  def unsubscribed
    Rails.logger.debug 'Unsubscribed from the completes funnel channel.'
  end

  private

  def set_resource
    case params[:resource]
    when 'Panel'
      Panel.find(params[:id])
    when 'Affiliate'
      Affiliate.find(params[:id])
    when 'Nonprofit'
      Nonprofit.find(params[:id])
    when 'Campaign'
      RecruitingCampaign.find(params[:id])
    end
  end
end
