# frozen_string_literal: true

class RemoveSomeColumnsFromOnboardings < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/BulkChangeTable
  def change
    remove_column :onboardings, :relevant_id_token, :string
    remove_column :onboardings, :relevant_id_started_at, :datetime
    remove_column :onboardings, :relevant_id_passed_at, :datetime
    remove_column :onboardings, :visit_code, :string
  end
  # rubocop:enable Rails/BulkChangeTable
end
