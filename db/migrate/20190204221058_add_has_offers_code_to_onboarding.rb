# frozen_string_literal: true

class AddHasOffersCodeToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :has_offers_code, :string
  end
end
