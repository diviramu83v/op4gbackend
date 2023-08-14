# frozen_string_literal: true

# Connects employees with their roles.
class EmployeeRole < ApplicationRecord
  belongs_to :employee
  belongs_to :role
end
