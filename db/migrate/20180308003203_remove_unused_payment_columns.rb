# frozen_string_literal: true

class RemoveUnusedPaymentColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :payments, :void, :boolean, default: false, null: false
    remove_column :payments, :payment_id, :integer
    remove_column :payments, :entries, :binary
    remove_column :payments, :void_at, :date
  end
end
