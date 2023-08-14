# frozen_string_literal: true

# View helpers for employee pages and cards.
module EmployeeHelper
  def employee_link(employee)
    return '?' if employee.blank?

    # TODO: Check permissions with cancancan. (link_to_if)
    # TODO: Add link.
    # link_to employee.name, employee
    employee.name
  end

  def employee_initials_link(employee)
    return '?' if employee.blank?

    # TODO: Check permissions with cancancan. (link_to_if)
    # TODO: Add link.
    # link_to employee.initials, employee
    employee.initials
  end
end
