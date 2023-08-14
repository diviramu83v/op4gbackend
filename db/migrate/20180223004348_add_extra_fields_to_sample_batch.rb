# frozen_string_literal: true

class AddExtraFieldsToSampleBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :sample_batches, :label, :string
    add_column :sample_batches, :email_subject, :string
    add_column :sample_batches, :description, :text

    SampleBatch.find_each { |batch| batch.update_attributes(email_subject: 'New Batch') }

    change_column_null(:sample_batches, :email_subject, false)
  end
end
