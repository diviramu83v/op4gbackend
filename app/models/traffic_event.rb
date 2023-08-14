# frozen_string_literal: true

# A traffic event records different milestones that happen for a specific
#   traffic record. Primarily for tracking fraud, but also other events.
class TrafficEvent < ApplicationRecord
  belongs_to :onboarding
  belongs_to :traffic_check, optional: true

  CATEGORIES = %w[fraud suspicious info].freeze

  validates :category, :message, presence: true
  validate :category_in_categories_list

  scope :fraudulent, -> { where(category: 'fraud') }
  scope :suspicious, -> { where(category: 'suspicious') }
  scope :by_first_created, -> { order('created_at') }
  scope :by_id, -> { order('id') }

  private

  def category_in_categories_list
    return if category.blank?

    errors.add(:category, 'must be in the category list') unless CATEGORIES.include?(category)
  end
end
