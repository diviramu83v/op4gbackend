# frozen_string_literal: true

class RemovePremiumStatusFromPanelist < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :panelists, :premium_status, :string }
  end
end
