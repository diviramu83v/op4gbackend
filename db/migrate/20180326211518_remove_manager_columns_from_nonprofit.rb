# frozen_string_literal: true

class RemoveManagerColumnsFromNonprofit < ActiveRecord::Migration[5.1]
  def change
    remove_column :nonprofits, :manager_name, :string
    remove_column :nonprofits, :manager_email, :string
  end
end
