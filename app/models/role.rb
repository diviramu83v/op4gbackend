# frozen_string_literal: true

# A role helps manage access to different parts of the application.
class Role < ApplicationRecord
  has_many :employee_roles, dependent: :destroy
  has_many :employees, through: :employee_roles, inverse_of: :roles
end
