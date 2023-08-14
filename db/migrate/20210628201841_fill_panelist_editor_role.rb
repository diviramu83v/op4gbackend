# frozen_string_literal: true

class FillPanelistEditorRole < ActiveRecord::Migration[5.2]
  def change
    Employee.joins(:employee_roles).where('employee_roles.role_id = ? OR employee_roles.role_id = ?', 7, 45).uniq.each do |employee|
      role = Role.find_by(name: 'Panelist editor')
      EmployeeRole.create!(employee: employee, role: role)
    end
  end
end
