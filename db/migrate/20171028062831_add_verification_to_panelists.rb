# frozen_string_literal: true

class AddVerificationToPanelists < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :phone, :string
    add_column :panelists, :phone_verification_code, :integer
    add_column :panelists, :phone_verified_at, :datetime
    add_column :panelists, :email_verified_at, :datetime
  end
end
