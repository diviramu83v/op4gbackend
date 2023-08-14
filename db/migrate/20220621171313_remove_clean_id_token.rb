# frozen_string_literal: true

class RemoveCleanIdToken < ActiveRecord::Migration[6.1]
  # rubocop:disable Rails/BulkChangeTable
  def change
    remove_column :onboardings, :clean_id_token, :string
    remove_column :onboardings, :clean_id_device_id, :bigint
    remove_column :onboardings, :clean_id_data, :json
    remove_column :onboardings, :clean_id_started_at, :datetime
    remove_column :onboardings, :clean_id_passed_at, :datetime
  end
  # rubocop:enable Rails/BulkChangeTable
end
