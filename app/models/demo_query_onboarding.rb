# frozen_string_literal: true

# Connects panelists to a query based on the encoded UID.
class DemoQueryOnboarding < ApplicationRecord
  belongs_to :demo_query
  belongs_to :onboarding
end
