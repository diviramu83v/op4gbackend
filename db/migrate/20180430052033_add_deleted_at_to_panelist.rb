# frozen_string_literal: true

class AddDeletedAtToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :deleted_at, :datetime
  end
end
