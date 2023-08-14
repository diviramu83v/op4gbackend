# frozen_string_literal: true

class AddAnswersToPrescreenerQuestions < ActiveRecord::Migration[5.2]
  def change
    change_table :prescreener_questions, bulk: true do |t|
      t.string :answer_options, array: true, default: []
      t.string :target_answers, array: true, default: []
      t.string :selected_answers, array: true, default: []
    end
  end
end
