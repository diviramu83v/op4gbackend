# frozen_string_literal: true

# Connects queries to MSAs for filtering.
class DemoQueryMsa < ApplicationRecord
  belongs_to :demo_query
  belongs_to :msa
end
