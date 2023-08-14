# frozen_string_literal: true

# Connects queries to divisions for filtering.
class DemoQueryDivision < ApplicationRecord
  belongs_to :demo_query
  belongs_to :division
end
