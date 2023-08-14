# frozen_string_literal: true

class AddEmployeeToCintFeasibilities < ActiveRecord::Migration[5.2]
  def change
    add_reference :cint_feasibilities, :employee, foreign_key: true
  end
end
