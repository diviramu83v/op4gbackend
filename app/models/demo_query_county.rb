# frozen_string_literal: true

# Connects queries to counties for filtering.
class DemoQueryCounty < ApplicationRecord
  belongs_to :demo_query
  belongs_to :county
end
