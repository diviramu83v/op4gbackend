# frozen_string_literal: true

class AddApiTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :api_tokens do |t|
      t.string :token, null: false, unique: true
      t.string :status, null: false, default: 'active'
      t.string :description, null: false
      t.timestamps
    end

    add_column :surveys, :added_to_api_at, :datetime
  end
end
