# frozen_string_literal: true

class AddOrderToDecodedUid < ActiveRecord::Migration[5.1]
  def change
    add_column :decoded_uids, :entry_number, :integer, null: false, default: 0
  end
end
