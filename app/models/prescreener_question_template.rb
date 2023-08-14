# frozen_string_literal: true

# prescreener questions will be new and cool
class PrescreenerQuestionTemplate < ApplicationRecord
  include RailsSortable::Model
  include PgSearch::Model
  pg_search_scope :search_by_keyword, against: :body, using: :tsearch

  set_sortable :sort_order

  attr_accessor :answers

  enum question_type: {
    single_answer: 'single_answer',
    multi_answer: 'multi_answer',
    open_end: 'open_end'
  }

  enum passing_criteria: {
    pass_if_any_selected: 'pass_if_any_selected',
    pass_if_all_selected: 'pass_if_all_selected',
    fail_if_any_selected: 'fail_if_any_selected'
  }

  enum status: {
    active: 'active',
    deleted: 'deleted'
  }

  validates :question_type, :status, :passing_criteria, presence: true

  belongs_to :survey
  has_many :prescreener_answer_templates, dependent: :destroy, inverse_of: :prescreener_question_template
  has_many :prescreener_questions, dependent: :nullify, inverse_of: :template

  before_validation :remove_leading_and_trailing_space

  before_create :set_sort_order

  scope :by_sort_order, -> { order('sort_order') }

  validate :passing_criteria_makes_sense

  def clone_answers(cloned_question)
    prescreener_answer_templates.order(:id).each do |answer|
      PrescreenerAnswerTemplate.create(body: answer.body,
                                       target: answer.target,
                                       sort_order: answer.sort_order,
                                       prescreener_question_template: cloned_question)
    end
  end

  private

  def remove_leading_and_trailing_space
    self.body = body.strip
  end

  def passing_criteria_makes_sense
    return unless pass_if_all_selected?
    return if multi_answer?

    errors.add(:passing_criteria, "\"Pass if all selected\" option doesn\'t work with #{question_type.humanize.downcase}")
  end

  def set_sort_order
    self.sort_order = survey.prescreener_question_templates.count
  end
end
