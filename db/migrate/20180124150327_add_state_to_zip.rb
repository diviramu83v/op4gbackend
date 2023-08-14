# frozen_string_literal: true

class AddStateToZip < ActiveRecord::Migration[5.1]
  def change
    add_reference :zips, :state, foreign_key: true, null: false
  end
end
