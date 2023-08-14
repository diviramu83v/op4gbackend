# frozen_string_literal: true

class AddWelcomedAtToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :welcomed_at, :datetime
  end
end
