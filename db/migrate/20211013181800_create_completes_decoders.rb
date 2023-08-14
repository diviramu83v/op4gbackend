# frozen_string_literal: true

class CreateCompletesDecoders < ActiveRecord::Migration[5.2]
  def change
    create_table :completes_decoders do |t|
      t.text :encoded_uids, null: false
      t.bigint :employee_id, null: false
      t.datetime :decoded_at

      t.timestamps
    end
  end
end
