# frozen_string_literal: true

class AddEmployeeToDisqoFeasibilities < ActiveRecord::Migration[5.2]
  def change
    add_reference :disqo_feasibilities, :employee, foreign_key: true
  end
end
