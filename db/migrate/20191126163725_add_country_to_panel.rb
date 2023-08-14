# frozen_string_literal: true

class AddCountryToPanel < ActiveRecord::Migration[5.1]
  def change
    add_reference :panels, :country, foreign_key: true
  end
end
