# frozen_string_literal: true

class GiveJoshOperationsManagerRole < ActiveRecord::Migration[6.1]
  def change
    employee = Employee.find(153)
    role = Role.find(6)
    EmployeeRole.create(employee: employee, role: role)
  end
end
