# frozen_string_literal: true

# These are answer options for SchlesingerQualificationQuestions
class SchlesingerQualificationAnswer < ApplicationRecord
  belongs_to :qualification_question, inverse_of: :qualification_answers, class_name: 'SchlesingerQualificationQuestion'

  def self.answers_hash
    all.each_with_object({}) do |answer, hash|
      hash[answer['answer_id']] = answer.text
    end
  end
end
