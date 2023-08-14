# frozen_string_literal: true

class RemoveImportedDataFromSampleBatches < ActiveRecord::Migration[5.2]
  def change
    remove_column :sample_batches, :imported_data, :text
  end
end
