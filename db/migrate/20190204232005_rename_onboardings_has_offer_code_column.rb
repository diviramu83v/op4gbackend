# frozen_string_literal: true

class RenameOnboardingsHasOfferCodeColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :onboardings, :has_offers_code, :visit_code
  end
end
