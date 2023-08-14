# frozen_string_literal: true

class CreateSchlesingerQualificationAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :schlesinger_qualification_answers, primary_key: :answer_id do |t|
      t.string :text
      t.string :answer_code
      t.bigint :qualification_question_id

      t.timestamps
    end

    add_foreign_key :schlesinger_qualification_answers, :schlesinger_qualification_questions, column: 'qualification_question_id', primary_key: 'qualification_id'
  end
end
