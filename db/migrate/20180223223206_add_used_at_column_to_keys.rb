# frozen_string_literal: true

class AddUsedAtColumnToKeys < ActiveRecord::Migration[5.1]
  def change
    add_column :keys, :used_at, :datetime
  end
end
