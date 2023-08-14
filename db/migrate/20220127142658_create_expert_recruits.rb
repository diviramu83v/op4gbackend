# frozen_string_literal: true

class CreateExpertRecruits < ActiveRecord::Migration[5.2]
  def change
    create_table :expert_recruits do |t|
      t.string :email, null: false
      t.string :token, null: false
      t.references :survey, foreign_key: true, null: false

      t.timestamps
    end
  end
end
