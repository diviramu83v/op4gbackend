# frozen_string_literal: true

class RemoveDonationsTable < ActiveRecord::Migration[5.1]
  def change
    drop_table 'donations' do |t|
      t.integer 'panelist_id', null: false
      t.integer 'non_profit_id', null: false
      t.integer 'amount_cents', default: 0, null: false
      t.boolean 'npom', default: false, null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.bigint 'sample_batch_id'
    end
  end
end
