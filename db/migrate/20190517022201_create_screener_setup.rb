# frozen_string_literal: true

class CreateScreenerSetup < ActiveRecord::Migration[5.1]
  def change
    create_table :screener_setups do |t|
      t.string :question
      t.string :answers, array: true, default: []
      t. references :survey, null: false, foreign_key: true

      t.timestamps
    end
  end
end
