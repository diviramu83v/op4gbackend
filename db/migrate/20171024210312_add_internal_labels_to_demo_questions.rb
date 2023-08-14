# frozen_string_literal: true

class AddInternalLabelsToDemoQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :demo_questions, :body, :string, null: false
    add_column :demo_questions, :button_label, :string
  end
end
