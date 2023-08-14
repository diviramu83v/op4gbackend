# frozen_string_literal: true

class CreatePrescreenerQuestionTemplate < ActiveRecord::Migration[5.2]
  def change
    create_table :prescreener_question_templates do |t|
      t.string :body
      t.references :survey, foreign_key: true, null: false
      t.string :question_type, null: false
      t.string :passing_criteria, null: false

      t.timestamps
    end
  end
end
