# frozen_string_literal: true

class RemoveTargetCompletionsFromCampaign < ActiveRecord::Migration[5.1]
  def change
    remove_column :campaigns, :target_completions, :integer
  end
end
