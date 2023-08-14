# frozen_string_literal: true

class AddStatusToQuota < ActiveRecord::Migration[5.2]
  safety_assured

  def change
    add_column :quotas, :status, :string, null: false, default: 'paused'
  end
end
