# frozen_string_literal: true

class AddAffiliateIdToConversions < ActiveRecord::Migration[5.1]
  def change
    add_reference :conversions, :affiliate, foreign_key: true
  end
end
