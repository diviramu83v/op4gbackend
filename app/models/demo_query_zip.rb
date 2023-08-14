# frozen_string_literal: true

# Connects queries to ZIP codes for filtering.
class DemoQueryZip < ApplicationRecord
  belongs_to :demo_query
  belongs_to :zip_code
end
