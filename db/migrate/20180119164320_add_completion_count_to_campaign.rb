# frozen_string_literal: true

class AddCompletionCountToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :confirmed_completion_count, :integer
  end
end
