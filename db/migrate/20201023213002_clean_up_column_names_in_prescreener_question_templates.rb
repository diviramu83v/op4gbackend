# frozen_string_literal: true

class CleanUpColumnNamesInPrescreenerQuestionTemplates < ActiveRecord::Migration[5.2]
  safety_assured

  def change
    rename_column :prescreener_question_templates, :question, :body
    remove_column :prescreener_question_templates, :answers, :string
    add_column :prescreener_question_templates, :question_type, :string, null: false, default: 'single_answer'
    add_column :prescreener_question_templates, :passing_criteria, :string, null: false, default: 'pass_if_any_selected'
  end
end
