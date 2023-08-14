# frozen_string_literal: true

class AddUniqueIndexToDemoAnswers < ActiveRecord::Migration[5.1]
  def change
    add_index :demo_answers, [:panelist_id, :demo_option_id], unique: true
  end
end
