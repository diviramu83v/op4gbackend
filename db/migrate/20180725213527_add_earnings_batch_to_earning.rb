# frozen_string_literal: true

class AddEarningsBatchToEarning < ActiveRecord::Migration[5.1]
  def change
    add_reference :earnings, :earnings_batch, foreign_key: true
  end
end
