# frozen_string_literal: true

# a test uid is used as the uid when testing survey links
class TestUid < ApplicationRecord
  belongs_to :employee
  belongs_to :onramp

  scope :newest_first, -> { order('created_at DESC') }
end
