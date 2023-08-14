# frozen_string_literal: true

class BackfillIpAddressBlockCategory < ActiveRecord::Migration[5.2]
  def change
    IpAddress.where.not(category: 'allow').where(block_category: nil).find_each do |ip_address|
      if ip_address.category == 'deny-manual'
        ip_address.manual!
      else
        ip_address.auto!
      end
    end
  end
end
