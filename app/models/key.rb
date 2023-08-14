# frozen_string_literal: true

# A key is sent when starting a client survey as a security measure.
class Key < ApplicationRecord
  IMPORT_LIMIT = 50_000

  belongs_to :survey

  validates :value, presence: true

  scope :used, -> { where.not(used_at: nil) }
  scope :unused, -> { where(used_at: nil) }
  scope :by_created_at, -> { order(:created_at) }

  def removable?
    unused?
  end

  def used?
    used_at.present?
  end

  def unused?
    !used?
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << %w[key created_at used_at]

      all.find_each do |key|
        csv << [key.value, key.created_at, key.used_at]
      end
    end
  end
end
