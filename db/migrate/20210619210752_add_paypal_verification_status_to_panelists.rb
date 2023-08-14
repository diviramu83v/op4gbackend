# frozen_string_literal: true

class AddPaypalVerificationStatusToPanelists < ActiveRecord::Migration[5.2]
  def change
    safety_assured do
      change_column :panelists, :paypal_verification_status, :string, default: 'not_verified'
      change_column :panelists, :paypal_verification_status, :string, null: false
    end
  end
end
