# frozen_string_literal: true

class BackportDefaultLockFlagToPanelists < ActiveRecord::Migration[5.2]
  def change
    Panelist.select(:id).find_in_batches.with_index do |records, index|
      puts "Processing batch #{index + 1}\r"
      Panelist.where(id: records).update_all(lock_flag: false)
    end
  end
end
