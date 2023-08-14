# frozen_string_literal: true

class AddTokenToSurvey < ActiveRecord::Migration[5.1]
  def change
    add_column :surveys, :token, :string, null: false
    add_index :surveys, :token, unique: true
  end
end
