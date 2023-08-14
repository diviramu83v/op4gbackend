# frozen_string_literal: true

class AddEmployeeRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :name, unique: true

      t.timestamps
    end

    create_table :employee_roles, id: false do |t|
      t.integer :employee_id
      t.integer :role_id

      t.timestamps
    end

    add_foreign_key :employee_roles, :employees
    add_foreign_key :employee_roles, :roles
  end
end
