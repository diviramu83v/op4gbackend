# frozen_string_literal: true

class AddReferenceFromPrescreenerQuestionToPrescreenerQuestionTemplate < ActiveRecord::Migration[5.2]
  def change
    add_reference :prescreener_questions, :prescreener_question_template, foreign_key: true
  end
end
