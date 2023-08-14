# frozen_string_literal: true

class CreateTrafficSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :traffic_steps do |t|
      t.references :onboarding, foreign_key: true, null: false
      t.integer :sort_order, default: 0, null: false
      t.string :when
      t.string :category
      t.string :token, null: false
      t.string :status

      t.timestamps
    end
  end
end
