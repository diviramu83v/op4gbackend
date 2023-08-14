# frozen_string_literal: true

class AddArchivedAtToNonprofit < ActiveRecord::Migration[5.1]
  def change
    add_column :nonprofits, :archived_at, :timestamp
  end
end
