# frozen_string_literal: true

class ChangeIncentiveBatchCsvData < ActiveRecord::Migration[6.0]
  # rubocop:disable Rails/BulkChangeTable
  def change
    remove_column :incentive_batches, :csv_data, :text
    add_column :incentive_batches, :csv_data, :text
  end
  # rubocop:enable Rails/BulkChangeTable
end
