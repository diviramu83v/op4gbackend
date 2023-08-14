# frozen_string_literal: true

class AddTrackingColumnsToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :offer_code, :string
    add_column :panelists, :affiliate_code, :string
    add_column :panelists, :sub_affiliate_code, :string
    add_column :panelists, :sub_affiliate_code_2, :string
  end
end
