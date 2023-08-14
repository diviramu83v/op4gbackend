# frozen_string_literal: true

class AddRegionDataToZip < ActiveRecord::Migration[5.1]
  def change
    add_reference :zips, :region, foreign_key: true, null: false
    add_reference :zips, :division, foreign_key: true, null: false
    add_reference :zips, :county, foreign_key: true
  end
end
