# frozen_string_literal: true

# An email description is a part of the survey emails that varies depending on
#   the product for a given project.
class EmailDescription < ApplicationRecord
  scope :default, -> { find_by(default: true) }
  scope :full_service, -> { find_by(name: 'Full service') }
end
