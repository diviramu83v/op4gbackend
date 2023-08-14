# frozen_string_literal: true

class AddLastActivityAtToPanelists < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :last_activity_at, :datetime
  end
end
