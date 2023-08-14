# frozen_string_literal: true

# A demographic question is a question that applies to a specific panel &
#   country.
# Example: 'What is your gender?'
class DemoQuestion < ApplicationRecord
  belongs_to :country, optional: true
  belongs_to :demo_questions_category
  belongs_to :parent_question, optional: true, inverse_of: :follow_up_questions, class_name: 'DemoQuestion', foreign_key: :follow_up_to_question_id

  has_many :demo_options, dependent: :destroy, inverse_of: :demo_question
  has_many :follow_up_questions, dependent: :nullify, inverse_of: :parent_question, class_name: 'DemoQuestion', foreign_key: :follow_up_to_question_id

  has_one :panel, through: :demo_questions_category

  scope :binary, -> { joins(:demo_options).group('demo_questions.id').having('count(*) = 2') }
  scope :not_archived, -> { where(archived_at: nil) }
  scope :required_for_panelist, ->(panelist) { not_archived.where(follow_up_to_question_id: nil).or(follow_up_questions_for_panelist(panelist)) }
  scope :for_panel, ->(panel) { joins(:demo_questions_category).merge(DemoQuestionsCategory.for_panel(panel)) if panel.present? }
  scope :for_category, ->(category) { where(demo_questions_category: category) if category.present? }
  scope :by_sort_order, -> { order('sort_order') }

  validates :body, :input_type, presence: true

  alias options demo_options

  INPUT_TYPE_OPTIONS = {
    Radio: 'radio',
    'Select box': 'single'
  }.freeze

  # Written as a method instead of using the scope syntax because it's a
  # special case with how the country not being present is handled. Seemed too
  # complex to handle as a one-liner.
  def self.for_country(country)
    return where(country_id: nil) if country.blank?

    where('country_id = ? OR country_id IS NULL', country.id)
  end

  def self.follow_up_questions_for_panelist(panelist)
    DemoQuestion.where(demo_questions: { id: panelist.demo_questions.pluck(:follow_up_question_ids)&.flatten })
  end

  def self.for_options(options)
    joins(:demo_options).where(demo_options: { id: options.map(&:id) })
  end

  def demo_options_for_panelist(panelist)
    demo_option = panelist.demo_options.find_by(demo_question_id: parent_question&.id)
    demo_option.present? ? demo_options.where(subject: demo_option.label).order(:sort_order) : demo_options.order(:sort_order)
  end

  def single_answer?
    input_type == 'single' || input_type == 'radio'
  end

  def possible_answers(hidden_options)
    options.by_sort_order - hidden_options
  end

  def label_different_than_body?
    label != body
  end

  def slug
    label.parameterize.tr('-', '_')
  end

  # Use the value in the database or the label field if there isn't one.
  def button_label
    super || label
  end
end
