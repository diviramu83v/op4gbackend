# frozen_string_literal: true

class AddAgeToPanelists < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :age, :integer
    add_column :panelists, :update_age_at, :date

    remove_column :panelists, :birthdate, :string
    add_column :panelists, :birthdate, :date
  end
end
