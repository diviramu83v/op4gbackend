# frozen_string_literal: true

class CreatePrescreenerLibraryQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :prescreener_library_questions do |t|
      t.string :question, null: false
      t.text :answers, default: [], array: true

      t.timestamps
    end
  end
end
