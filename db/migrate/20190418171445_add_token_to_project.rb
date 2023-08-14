# frozen_string_literal: true

class AddTokenToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :relevant_id_token, :string, null: true
  end
end
