# frozen_string_literal: true

class ChangeColumnNamesInOffersAndAffiliates < ActiveRecord::Migration[5.1]
  def change
    rename_column :offers, :offer_code, :code
    rename_column :offers, :offer_name, :name
    rename_column :affiliates, :affiliate_code, :code
    rename_column :affiliates, :affiliate_name, :name
  end
end
