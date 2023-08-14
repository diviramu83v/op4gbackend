# frozen_string_literal: true

class RemoveDeactivatedColumFromPanelist < ActiveRecord::Migration[5.1]
  def change
    remove_column :panelists, :deactivated_at, :datetime
  end
end
