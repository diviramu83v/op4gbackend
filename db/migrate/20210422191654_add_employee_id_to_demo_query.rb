# frozen_string_literal: true

class AddEmployeeIdToDemoQuery < ActiveRecord::Migration[5.2]
  def change
    add_reference :demo_queries, :employee, foreign_key: true
  end
end
