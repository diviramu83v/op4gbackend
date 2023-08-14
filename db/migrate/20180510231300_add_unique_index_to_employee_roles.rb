# frozen_string_literal: true

class AddUniqueIndexToEmployeeRoles < ActiveRecord::Migration[5.1]
  def change
    add_index :employee_roles, [:employee_id, :role_id], unique: true
  end
end
