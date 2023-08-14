# frozen_string_literal: true

class CreateSchlesingerQualificationQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :schlesinger_qualification_questions, primary_key: :qualification_id do |t|
      t.string :name
      t.string :text
      t.integer :qualification_category_id
      t.integer :qualification_type_id

      t.timestamps
    end
  end
end
