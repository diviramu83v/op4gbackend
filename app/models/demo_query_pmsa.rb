# frozen_string_literal: true

# Connects queries to PMSAs for filtering.
class DemoQueryPmsa < ApplicationRecord
  belongs_to :demo_query
  belongs_to :pmsa
end
