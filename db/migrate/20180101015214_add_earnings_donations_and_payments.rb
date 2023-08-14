# frozen_string_literal: true

class AddEarningsDonationsAndPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :donations do |t|
      t.integer :work_order_id
      t.integer :panelist_id,   null: false
      t.integer :non_profit_id, null: false
      t.integer :amount_cents,  null: false, default: 0
      t.boolean :npom,          null: false, default: false

      t.timestamps
    end

    add_foreign_key :donations, :panelists

    create_table :earnings do |t|
      t.integer  :work_order_id,  null: false
      t.integer  :panelist_id,    null: false
      t.integer  :amount_cents,   ∂null: false, default: 0

      t.timestamps
    end

    add_foreign_key :earnings, :panelists
    add_foreign_key :earnings, :work_orders

    create_table :payments do |t|
      t.integer :panelist_id,   null: false
      t.integer :amount_cents,  null: false, default: 0
      t.boolean :void,          null: false, default: false
      t.integer :payment_id
      t.binary  :entries
      t.date    :paid_at, null: false
      t.date    :void_at

      t.timestamps
    end

    add_foreign_key :payments, :panelists

    add_column :sample_batches, :incentive_cents, :integer
    add_column :survey_participants, :sample_batch_id, :integer
  end
end
