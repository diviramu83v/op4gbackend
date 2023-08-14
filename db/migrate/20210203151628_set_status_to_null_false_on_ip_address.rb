# frozen_string_literal: true

class SetStatusToNullFalseOnIpAddress < ActiveRecord::Migration[5.2]
  def change
    change_column_null :ip_addresses, :status, false
  end
end
