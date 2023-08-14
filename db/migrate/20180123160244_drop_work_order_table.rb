# frozen_string_literal: true

class DropWorkOrderTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :projects, :work_order_id, :integer
    remove_column :donations, :work_order_id, :integer
    remove_column :earnings, :work_order_id, :integer

    add_reference :donations, :sample_batch, foreign_key: true
    add_reference :earnings, :sample_batch, foreign_key: true

    drop_table :work_orders do |t|
      t.integer 'number'
      t.references 'salesperson'
    end
  end
end
