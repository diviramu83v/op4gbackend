# frozen_string_literal: true

class AddInDangerAtToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :in_danger_at, :datetime
  end
end
