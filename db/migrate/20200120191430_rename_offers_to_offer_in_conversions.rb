# frozen_string_literal: true

class RenameOffersToOfferInConversions < ActiveRecord::Migration[5.1]
  def change
    rename_column :conversions, :offers_id, :offer_id
  end
end
