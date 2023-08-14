# frozen_string_literal: true

class AddAddressLineTwoToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :address_line_two, :string
  end
end
