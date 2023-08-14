# frozen_string_literal: true

class AddDefaultStatusToIpAddresses < ActiveRecord::Migration[5.2]
  def change
    change_column_default :ip_addresses, :status, from: nil, to: 'allowed'
  end
end
