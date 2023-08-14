# frozen_string_literal: true

class AddTemporaryAnswersToPrescreenerQuestionTemplate < ActiveRecord::Migration[5.2]
  safety_assured

  def change
    add_column :prescreener_question_templates, :temporary_answers, :text, array: true, default: []
  end
end
