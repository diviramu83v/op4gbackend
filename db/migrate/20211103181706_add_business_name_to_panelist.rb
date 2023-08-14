# frozen_string_literal: true

class AddBusinessNameToPanelist < ActiveRecord::Migration[5.2]
  def change
    add_column :panelists, :business_name, :string
  end
end
