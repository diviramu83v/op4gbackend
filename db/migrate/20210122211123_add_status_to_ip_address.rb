# frozen_string_literal: true

class AddStatusToIpAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :ip_addresses, :status, :string
  end
end
