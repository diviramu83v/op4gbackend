# frozen_string_literal: true

# Temporary class to handle connecting queries to the states selected on panelist signup.
# TODO: Remove this and combine all state handling into one class.
class DemoQueryStateCode < ApplicationRecord
  belongs_to :demo_query

  validates :code, presence: true
end
