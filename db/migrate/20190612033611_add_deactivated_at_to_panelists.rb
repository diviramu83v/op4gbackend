# frozen_string_literal: true

class AddDeactivatedAtToPanelists < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :deactivated_at, :datetime
  end
end
