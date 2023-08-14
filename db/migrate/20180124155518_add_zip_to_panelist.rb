# frozen_string_literal: true

class AddZipToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_reference :panelists, :zip, foreign_key: true
  end
end
