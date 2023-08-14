# frozen_string_literal: true

class AddManagerColumnsBackToNonprofit < ActiveRecord::Migration[5.1]
  def change
    add_column :nonprofits, :manager_name, :string
    add_column :nonprofits, :manager_email, :string
  end
end
