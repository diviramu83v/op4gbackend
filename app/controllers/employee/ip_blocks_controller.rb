# frozen_string_literal: true

class Employee::IpBlocksController < Employee::SecurityBaseController
  authorize_resource class: 'IpAddress'
  before_action :find_ip_address

  def create
    @ip_address.manually_block(reason: params[:ip_address][:blocked_reason])

    redirect_to ip_address_url(@ip_address.id)
  end

  def destroy
    @ip_address.unblock

    redirect_to ip_address_url(@ip_address.id)
  end

  private

  def find_ip_address
    @ip_address = IpAddress.find_by(id: params[:ip_address_id])
  end
end
