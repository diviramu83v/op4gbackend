# frozen_string_literal: true

class DropEarningsTable < ActiveRecord::Migration[5.1]
  def change
    drop_table 'earnings' do |t|
      t.integer 'panelist_id', null: false
      t.integer 'amount_cents', default: 0
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.bigint 'sample_batch_id'
    end
  end
end
