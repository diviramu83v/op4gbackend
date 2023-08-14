# frozen_string_literal: true

class AddAbbreviationToPanel < ActiveRecord::Migration[5.1]
  def change
    add_column :panels, :abbreviation, :string
  end
end
