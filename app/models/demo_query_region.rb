# frozen_string_literal: true

# Connects queries to regions for filtering.
class DemoQueryRegion < ApplicationRecord
  belongs_to :demo_query
  belongs_to :region
end
