# frozen_string_literal: true

class CreatePrescreenerAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :prescreener_answers do |t|
      t.string :body, null: false
      t.boolean :target, null: false, default: false
      t.boolean :chosen, null: false, default: false
      t.string :open_end_answer
      t.references :onboarding, null: false, foreign_key: true
      t.references :prescreener_question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
