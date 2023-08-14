# frozen_string_literal: true

class AddSuspendedAtToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :suspended_at, :datetime
  end
end
