# frozen_string_literal: true

class CreatePrescreenerQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :prescreener_questions do |t|
      t.string :question
      t.string :answers, default: [], array: true
      t.references :onboarding, foreign_key: true, null: false
      t.string :token, null: false
      t.string :status, default: 'incomplete'

      t.timestamps
    end
  end
end
