# frozen_string_literal: true

class AddTargetAndCpiToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :target_completions, :integer
    add_column :campaigns, :cpi_cemts, :integer
  end
end
