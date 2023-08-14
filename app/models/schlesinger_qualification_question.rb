# frozen_string_literal: true

class SchlesingerQualificationQuestion < ApplicationRecord
  has_many :qualification_answers, inverse_of: :qualification_question,
                                   foreign_key: 'qualification_question_id',
                                   dependent: :destroy,
                                   class_name: 'SchlesingerQualificationAnswer'
  scope :ordered_by_id, -> { order(:qualification_id) }
end
