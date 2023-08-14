# frozen_string_literal: true

class RemovePaypalEmailColumnFromPanelist < ActiveRecord::Migration[5.2]
  def change
    remove_column :panelists, :paypal_email, :string
  end
end
