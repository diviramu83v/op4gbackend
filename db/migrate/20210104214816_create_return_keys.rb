# frozen_string_literal: true

class CreateReturnKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :return_keys do |t|
      t.string :token, null: false
      t.references :survey, null: false
      t.datetime :used_at

      t.timestamps
    end
  end
end
