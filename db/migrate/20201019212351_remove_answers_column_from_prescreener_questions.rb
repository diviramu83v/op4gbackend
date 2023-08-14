# frozen_string_literal: true

class RemoveAnswersColumnFromPrescreenerQuestions < ActiveRecord::Migration[5.2]
  def change
    remove_column :prescreener_questions, :answers, :string
  end
end
