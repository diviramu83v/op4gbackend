# frozen_string_literal: true

class CreateOnramps < ActiveRecord::Migration[5.1]
  def change
    create_table :onramps do |t|
      t.string :token, null: false
      t.references :campaign, foreign_key: true, null: false
      t.references :vendor_batch, foreign_key: true
      t.boolean :check_relevant_id, null: false, default: false
      t.boolean :check_recaptcha, null: false, default: false
      t.boolean :check_gate_survey, null: false, default: false
      t.boolean :check_phone_number, null: false, default: false

      t.timestamps
    end
  end
end
