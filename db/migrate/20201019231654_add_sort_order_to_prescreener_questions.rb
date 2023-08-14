# frozen_string_literal: true

class AddSortOrderToPrescreenerQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :prescreener_questions, :sort_order, :integer
    add_column :prescreener_questions, :question_type, :string
    add_column :prescreener_questions, :passing_criteria, :string
  end
end
