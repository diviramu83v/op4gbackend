# frozen_string_literal: true

class RemoveNonprofitsRoleFromEmployees < ActiveRecord::Migration[5.2]
  safety_assured

  def change
    nonprofit_role = Role.find_by(name: 'Nonprofits')
    Employee.find_each do |employee|
      next unless employee.roles.any? { |role| role.name == 'Nonprofits' }

      employee.roles.destroy(nonprofit_role)
    end
    nonprofit_role.destroy
  end
end
