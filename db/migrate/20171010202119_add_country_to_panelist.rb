# frozen_string_literal: true

class AddCountryToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_reference :panelists, :country, null: false, foreign_key: true
  end
end
