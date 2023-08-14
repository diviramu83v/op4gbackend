# frozen_string_literal: true

# A demographic answer represents one choice made by a panelist when filling
#   out their demographic information.
# Example: Panelist A chose the "male" option in answer to the question "what
#   is your gender?". Question is related to this record through the option
#   record.
class DemoAnswer < ApplicationRecord
  belongs_to :demo_option
  belongs_to :panelist, inverse_of: :demo_answers

  has_one :demo_question, through: :demo_option
  has_one :panel, through: :demo_question

  scope :for_category, lambda { |demo_category|
                         joins(:demo_question)
                           .merge(DemoQuestion.not_archived)
                           .where(demo_questions: { demo_questions_category_id: demo_category })
                       }

  alias option demo_option
end
