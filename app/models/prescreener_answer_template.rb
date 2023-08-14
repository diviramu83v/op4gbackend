# frozen_string_literal: true

# prescreener answers will be the options to prescreener question templates
class PrescreenerAnswerTemplate < ApplicationRecord
  include RailsSortable::Model
  set_sortable :sort_order

  belongs_to :prescreener_question_template, inverse_of: :prescreener_answer_templates

  scope :order_by_targets_first, -> { order(target: :desc) }
  scope :targets, -> { where(target: true) }
  scope :by_sort_order, -> { order('sort_order') }

  validates :body, presence: true
  before_save :downcase_body
  before_create :set_sort_order

  def downcase_body
    self.body = body.downcase&.strip
  end

  private

  def set_sort_order
    self.sort_order = prescreener_question_template.prescreener_answer_templates.count
  end
end
