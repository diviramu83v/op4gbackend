# frozen_string_literal: true

class Employee::IpAddressesController < Employee::SecurityBaseController
  authorize_resource class: 'IpAddress'

  def index
    redirect_to not_found_url unless context_valid?(params[:context])
    @ip_addresses = IpAddress.sort_by_context(params[:context]).page(params[:page]).per(100)
    @context = params[:context].capitalize
  end

  def show
    @ip_address = IpAddress.find_by(id: params[:id])
    @panelists = @ip_address.panelists.distinct.page(params[:panelists]).per(50)
    @onboardings = @ip_address.onboardings.most_recent_first.page(params[:page]).per(50)
  end

  private

  def context_valid?(context)
    %w[onboarding panelist].include?(context)
  end
end
