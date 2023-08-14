# frozen_string_literal: true

class CreateSampleBatches < ActiveRecord::Migration[5.1]
  def change
    create_table :sample_batches do |t|
      t.references :project, foreign_key: true, null: false

      t.timestamps
    end
  end
end
