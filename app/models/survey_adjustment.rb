# frozen_string_literal: true

# A survey adjustment changes the complete count to match what the client is
#   showing on their end.
class SurveyAdjustment < ApplicationRecord
  belongs_to :survey, touch: true

  attr_accessor :client_count

  before_validation :calculate_offset

  validates :client_count, presence: true, numericality: { only_integer: true }, unless: :persisted?
  validates :offset, presence: true, numericality: { only_integer: true }
  validate :offset_non_zero

  after_save :remove_client_count

  private

  def offset_non_zero
    return if offset.blank?

    errors.add(:offset, 'must be positive or negative') if offset.zero?
  end

  def calculate_offset
    return if client_count.blank?

    self.offset = client_count.to_i - survey.adjusted_complete_count
  end

  def remove_client_count
    self.client_count = nil if client_count.present?
  end
end
