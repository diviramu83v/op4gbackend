# frozen_string_literal: true

class AddIndexToPanelistStatus < ActiveRecord::Migration[5.1]
  def change
    add_index :panelists, :status
  end
end
