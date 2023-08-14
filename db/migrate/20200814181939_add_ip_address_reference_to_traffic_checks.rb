# frozen_string_literal: true

class AddIpAddressReferenceToTrafficChecks < ActiveRecord::Migration[5.2]
  def change
    change_column_null :traffic_checks, :ip_address, true
    add_reference :traffic_checks, :ip_address, foreign_key: { to_table: :ip_addresses }
  end
end
