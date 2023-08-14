# frozen_string_literal: true

# Keeps a list of age values. Mostly for querying easily and following the
#   same pattern as the other tables related to query filtering.
class Age < ApplicationRecord
  validates :value, presence: true

  scope :order_by_value, -> { order(:value) }

  def button_label
    "Age : #{value}"
  end

  def self.min_age
    pluck(:value).min
  end

  def self.max_age
    pluck(:value).max
  end
end
