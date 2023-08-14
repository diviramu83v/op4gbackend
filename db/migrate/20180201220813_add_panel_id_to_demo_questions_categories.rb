# frozen_string_literal: true

class AddPanelIdToDemoQuestionsCategories < ActiveRecord::Migration[5.1]
  def change
    remove_column :demo_questions_categories, :panel, :string
    add_reference :demo_questions_categories, :panel, foreign_key: true, null: false

    remove_column :demo_questions, :slug, :string
    add_reference :demo_questions, :demo_questions_category, foreign_key: true, null: false
  end
end
