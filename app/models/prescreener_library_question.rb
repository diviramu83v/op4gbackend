# frozen_string_literal: true

class PrescreenerLibraryQuestion < ApplicationRecord
  validates :question, presence: true
  validates :answers, presence: true
end
