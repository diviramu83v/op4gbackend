# frozen_string_literal: true

class AddTemporaryKeysToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :temporary_keys, :text, array: true
  end
end
