# frozen_string_literal: true

class AddPaypalAccountStatusToPanelist < ActiveRecord::Migration[5.2]
  def change
    safety_assured do
      add_column :panelists, :paypal_verified_at, :timestamp
      add_column :panelists, :paypal_uid, :string

      change_column_null :panelists, :paypal_email, true
    end
  end
end
