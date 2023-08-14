# frozen_string_literal: true

class AddPaymentTokenToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :payment_token, :string
    add_index :projects, :payment_token, unique: true

    Project.find_each(&:regenerate_payment_token)

    change_column_null(:projects, :payment_token, false)
  end
end
