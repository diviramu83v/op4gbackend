# frozen_string_literal: true

class RemoveIpAddressColumnFromTrafficCheck < ActiveRecord::Migration[5.2]
  def change
    remove_column :traffic_checks, :ip_address, :string
  end
end
