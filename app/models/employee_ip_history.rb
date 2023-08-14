# frozen_string_literal: true

# employee ip histories track ip's used by employees
class EmployeeIpHistory < ApplicationRecord
  belongs_to :employee
  belongs_to :ip_address
end
