# frozen_string_literal: true

class AddFlagCountToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :flag_count, :integer
  end
end
