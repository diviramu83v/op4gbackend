# frozen_string_literal: true

class AddTokenToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :token, :string
    add_index :panelists, :token, unique: true

    Panelist.find_each(&:regenerate_token)

    change_column_null(:panelists, :token, false)
  end
end
