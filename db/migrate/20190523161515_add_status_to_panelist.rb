# frozen_string_literal: true

class AddStatusToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :status, :integer, default: 0, null: false
  end
end
