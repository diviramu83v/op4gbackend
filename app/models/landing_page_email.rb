# frozen_string_literal: true

class LandingPageEmail < ApplicationRecord
  validates :email, presence: true
end
