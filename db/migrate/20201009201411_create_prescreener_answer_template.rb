# frozen_string_literal: true

class CreatePrescreenerAnswerTemplate < ActiveRecord::Migration[5.2]
  def change
    create_table :prescreener_answer_templates do |t|
      t.string :body, null: false
      t.boolean :target, default: false
      t.references :prescreener_question_template, foreign_key: true, null: false, index: { name: 'question_template' }

      t.timestamps
    end
  end
end
