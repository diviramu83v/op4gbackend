# frozen_string_literal: true

class RemoveSomeColumnsFromProjects < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/BulkChangeTable
  def change
    remove_column :projects, :sample_type_id, :bigint
    remove_column :projects, :project_type_id, :bigint
    remove_column :projects, :product_id, :bigint
  end
  # rubocop:enable Rails/BulkChangeTable
end
