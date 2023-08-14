# frozen_string_literal: true

class AddSalespersonToProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :temporary_salesperson, foreign_key: { to_table: :employees }
  end
end
