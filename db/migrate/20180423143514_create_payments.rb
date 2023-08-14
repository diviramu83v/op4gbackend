# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    drop_table 'payments' do |t|
      t.integer 'panelist_id', null: false
      t.integer 'amount_cents', default: 0, null: false
      t.date 'paid_at'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.bigint 'sample_batch_id', null: false
    end

    create_table :payments do |t|
      t.references :panelist, foreign_key: true, null: false
      t.integer :amount_cents, null: false, default: 0
      t.datetime :paid_at, null: false
      t.string :period, null: false
      t.datetime :voided_at
      t.text :imported_data

      t.timestamps
    end
  end
end
