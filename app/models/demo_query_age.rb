# frozen_string_literal: true

# Connects queries to ages for filtering.
class DemoQueryAge < ApplicationRecord
  belongs_to :demo_query
  belongs_to :age
end
