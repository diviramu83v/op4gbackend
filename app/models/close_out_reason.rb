# frozen_string_literal: true

class CloseOutReason < ApplicationRecord
  has_many :onboardings, dependent: :destroy

  validates :title, :category, presence: true

  scope :rejected, -> { where(category: 'rejected') }
  scope :frauds, -> { where(category: 'fraud') }
end
