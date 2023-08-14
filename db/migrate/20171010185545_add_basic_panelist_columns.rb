# frozen_string_literal: true

class AddBasicPanelistColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :email,       :string, null: false
    add_column :panelists, :first_name,  :string, null: false
    add_column :panelists, :last_name,   :string, null: false
    add_column :panelists, :birthdate,   :string
    add_column :panelists, :postal_code, :string, null: false
  end
end
