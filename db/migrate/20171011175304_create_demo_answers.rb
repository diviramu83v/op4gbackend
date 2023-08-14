# frozen_string_literal: true

class CreateDemoAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_answers do |t|
      t.references :panelist, foreign_key: true, null: false
      t.references :demo_option, foreign_key: true, null: false

      t.timestamps
    end
  end
end
