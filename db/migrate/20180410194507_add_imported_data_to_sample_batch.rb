# frozen_string_literal: true

class AddImportedDataToSampleBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :sample_batches, :imported_data, :text
  end
end
