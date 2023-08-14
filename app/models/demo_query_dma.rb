# frozen_string_literal: true

# Connects queries to DMAs for filtering.
class DemoQueryDma < ApplicationRecord
  belongs_to :demo_query
  belongs_to :dma
end
