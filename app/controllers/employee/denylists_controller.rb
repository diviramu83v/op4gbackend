# frozen_string_literal: true

require 'resolv'

class Employee::DenylistsController < Employee::SecurityBaseController
  authorize_resource class: 'IpAddress'

  def show
    @denylisted_ips = IpAddress.not_allowed.order(:address).page(params[:page]).per(100)
  end

  def new
    @denylist = IpAddress.new
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def create
    saved = []
    skipped = []
    invalid = []

    ip_list = array_from_text_blob(params[:ip_address]['address'])
    ip_list.each do |address|
      next if address == ''

      if address.match? Resolv::IPv4::Regex
        ip = IpAddress.find_or_create_by(address: address)

        if ip.blocked?
          skipped.push(ip.address)
        else
          ip.manually_block(reason: params[:ip_address][:blocked_reason])
          saved.push(ip.address)
        end
      else
        invalid.push(address)
      end
    end

    notice = []
    notice << "Addresses saved: #{saved.join(', ')}" if saved.any?
    notice << "Addresses already blocked: #{skipped.join(', ')}" if skipped.any?
    notice << "Invalid entries: #{invalid.join(', ')}" if invalid.any?
    flash[:notice] = notice.join('<br/>')

    redirect_to denylist_url
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  def destroy
    current_ip = IpAddress.find_by(address: params[:ip])
    current_ip.unblock

    redirect_to denylist_url
  end
end
