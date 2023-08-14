# frozen_string_literal: true

class AddPaypalVerifiedEnum < ActiveRecord::Migration[5.2]
  def change
    add_column :panelists, :paypal_verification_status, :string
  end
end
