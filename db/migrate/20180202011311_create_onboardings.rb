# frozen_string_literal: true

class CreateOnboardings < ActiveRecord::Migration[5.1]
  def change
    create_table :onboardings do |t|
      t.references :onramp, foreign_key: true, null: false
      t.string :uid, null: false
      t.string :token, null: false

      t.timestamps
    end
  end
end
