# frozen_string_literal: true

# this creates the table for the Disqo Quota Feasibilities
class CreateDisqoFeasibilities < ActiveRecord::Migration[5.2]
  def change
    create_table :disqo_feasibilities do |t|
      t.integer :daysInField
      t.integer :incidenceRate
      t.integer :loi
      t.integer :cpi
      t.integer :completes_wanted
      t.jsonb :qualifications, default: {}

      t.timestamps
    end
  end
end
