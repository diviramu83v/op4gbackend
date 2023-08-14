# frozen_string_literal: true

class AddEmployeeToSystemEvent < ActiveRecord::Migration[5.1]
  def change
    add_reference :system_events, :employee, foreign_key: true
  end
end
