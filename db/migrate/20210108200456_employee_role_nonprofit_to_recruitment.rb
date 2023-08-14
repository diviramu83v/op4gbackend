# frozen_string_literal: true

class EmployeeRoleNonprofitToRecruitment < ActiveRecord::Migration[5.2]
  safety_assured

  def change
    Employee.find_each do |employee|
      next unless employee.roles.any? { |role| role.name == 'Nonprofits' }
      next if employee.roles.any? { |role| role.name == 'Recruitment' }

      employee.employee_roles.create(role_id: 3)
    end
  end
end
