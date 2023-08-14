# frozen_string_literal: true

# The categories for panelist demographic questions
class DemoQuestionsCategory < ApplicationRecord
  belongs_to :panel

  has_many :demo_questions, dependent: :destroy

  scope :for_panel, ->(panel) { where(panel: panel) if panel.present? }
  scope :by_sort_order, -> { order('sort_order') }
end
