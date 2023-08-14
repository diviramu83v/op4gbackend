# frozen_string_literal: true

class AddUniqueIndexToPanelistPaypalEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :panelists, :paypal_email, unique: true
  end
end
