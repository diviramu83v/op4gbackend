# frozen_string_literal: true

# This model consolidates system event records to reduce the number of system
#   event records retained long-term.
class SystemEventSummary < ApplicationRecord
  validates :day_happened_at, :action, :count, presence: true
end
