# frozen_string_literal: true

class RemoveRelevantIdFields < ActiveRecord::Migration[5.2]
  def change
    # rubocop:disable Rails/BulkChangeTable
    remove_column :panelists, :relevant_id_score, :integer
    remove_column :panelists, :fraud_profile_score, :integer

    remove_column :onboardings, :dupe_score, :integer
    remove_column :onboardings, :fraud_profile_score, :integer
    remove_column :onboardings, :fraud_flag_count, :integer
    # rubocop:enable Rails/BulkChangeTable
  end
end
