# frozen_string_literal: true

# A panelist note is made by an employee about a particular panelist
class PanelistNote < ApplicationRecord
  belongs_to :panelist
  belongs_to :employee

  validates :body, presence: true

  scope :for_panelist, ->(panelist) { where(panelist: panelist) }
  scope :by_last_created, -> { order(created_at: :desc) }
end
