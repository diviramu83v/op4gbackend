# frozen_string_literal: true

class GiveAlyssaOperationsManagerRole < ActiveRecord::Migration[6.1]
  def change
    employee = Employee.find(193)
    role = Role.find(6)
    EmployeeRole.create(employee: employee, role: role)
  end
end
