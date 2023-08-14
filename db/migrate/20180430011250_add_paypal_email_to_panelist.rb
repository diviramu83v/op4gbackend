# frozen_string_literal: true

class AddPaypalEmailToPanelist < ActiveRecord::Migration[5.1]
  def up
    add_column :panelists, :paypal_email, :string

    Panelist.find_each do |panelist|
      panelist.update_attributes(paypal_email: panelist.email)
    end

    change_column_null :panelists, :paypal_email, false
  end

  def down
    remove_column :panelists, :paypal_email, :string, null: false
  end
end
