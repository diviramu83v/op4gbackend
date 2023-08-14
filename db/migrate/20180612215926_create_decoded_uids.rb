# frozen_string_literal: true

class CreateDecodedUids < ActiveRecord::Migration[5.1]
  def change
    create_table :decoded_uids do |t|
      t.references :decoding, foreign_key: true, null: false
      t.string :uid, null: false
      t.references :onboarding, foreign_key: true

      t.timestamps
    end
  end
end
