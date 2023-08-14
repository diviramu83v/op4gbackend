# frozen_string_literal: true

class AddUniqueIndexToEarnings < ActiveRecord::Migration[5.1]
  def change
    add_index :earnings, [:panelist_id, :sample_batch_id], unique: true
    add_index :earnings, [:panelist_id, :campaign_id], unique: true
  end
end
