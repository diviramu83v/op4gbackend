# frozen_string_literal: true

# Connects queries to states for filtering.
class DemoQueryState < ApplicationRecord
  belongs_to :demo_query
  belongs_to :state
end
