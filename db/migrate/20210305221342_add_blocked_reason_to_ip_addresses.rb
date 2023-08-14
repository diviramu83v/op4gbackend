# frozen_string_literal: true

class AddBlockedReasonToIpAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :ip_addresses, :blocked_reason, :string
  end
end
