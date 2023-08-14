# frozen_string_literal: true

class CreateWorkOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :work_orders do |t|
      t.integer :number

      t.timestamps
    end
  end
end
