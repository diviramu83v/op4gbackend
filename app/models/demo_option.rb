# frozen_string_literal: true

# A demographic option represents one possible answer to a certain
#   demographic question.
# Example: The question "what is your gender?" has two option records: "male"
#   and "female".
class DemoOption < ApplicationRecord
  belongs_to :demo_question

  has_many :demo_answers, dependent: :destroy
  has_many :panelists, through: :demo_answers, inverse_of: :demo_options

  has_many :demo_query_options, dependent: :destroy
  has_many :demo_queries, through: :demo_query_options, inverse_of: :demo_options

  # scope :for_list, ->(options) { where(id: options.map(&:id)) }
  scope :for_country, ->(country) { joins(:demo_question).where(demo_questions: { country_id: country.id }) if country.present? }
  scope :by_sort_order, -> { order('sort_order') }

  delegate :panel, to: :demo_question

  alias question demo_question

  def only_one_per_question?
    question.single_answer?
  end

  def button_label
    "#{question.button_label} : #{label}"
  end

  def panelist_count
    panelists.count
  end

  def translate
    key = label.parameterize.underscore

    if key.blank?
      label
    else
      I18n.t("demo_options.#{key}", default: label)
    end
  end
end
