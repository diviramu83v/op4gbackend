# frozen_string_literal: true

class AddPostalCodesToCintFeasibilities < ActiveRecord::Migration[5.2]
  def change
    add_column :cint_feasibilities, :postal_codes, :text
  end
end
