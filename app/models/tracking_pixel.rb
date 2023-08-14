# frozen_string_literal: true

# A url for a specific tracking pixel
class TrackingPixel < ApplicationRecord
  CATEGORY_SLUGS = %w[confirmation welcome].freeze
  CATEGORY_NAMES = ['Email confirmation page (double opt-in)', 'Welcome page (demos completed)'].freeze
  CATEGORIES = CATEGORY_SLUGS.zip(CATEGORY_NAMES).to_h.freeze

  validates :url, presence: true, uniqueness: true
  validates :category, presence: true, inclusion: { in: CATEGORY_SLUGS }

  scope :confirmation, -> { where(category: 'confirmation') }
  scope :welcome, -> { where(category: 'welcome') }
  scope :newest_first, -> { order('created_at DESC') }

  def category_description
    CATEGORIES[category]
  end
end
