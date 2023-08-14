# frozen_string_literal: true

class AddSlugToSchlesingerQualificationQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :schlesinger_qualification_questions, :slug, :string
    add_index :schlesinger_qualification_questions, :slug
  end
end
