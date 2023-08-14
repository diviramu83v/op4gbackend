# frozen_string_literal: true

class CreateCintFeasibilities < ActiveRecord::Migration[5.2]
  def change
    create_table :cint_feasibilities do |t|
      t.integer :days_in_field
      t.integer :incidence_rate
      t.integer :loi
      t.integer :cpi
      t.integer :limit
      t.integer :country_id
      t.integer :min_age
      t.integer :max_age
      t.text :variable_ids, default: [], array: true
      t.integer :number_of_panelists

      t.timestamps
    end
  end
end
