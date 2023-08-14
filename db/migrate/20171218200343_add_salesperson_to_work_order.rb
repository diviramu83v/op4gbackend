# frozen_string_literal: true

class AddSalespersonToWorkOrder < ActiveRecord::Migration[5.1]
  def change
    add_reference :work_orders, :salesperson, foreign_key: { to_table: :employees }
  end
end
