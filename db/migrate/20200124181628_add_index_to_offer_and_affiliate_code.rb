# frozen_string_literal: true

class AddIndexToOfferAndAffiliateCode < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def change
    add_index :panelists, :offer_code, algorithm: :concurrently
    add_index :panelists, :affiliate_code, algorithm: :concurrently
  end
end
