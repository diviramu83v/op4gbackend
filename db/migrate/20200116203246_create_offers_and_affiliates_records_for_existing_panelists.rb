# frozen_string_literal: true

class CreateOffersAndAffiliatesRecordsForExistingPanelists < ActiveRecord::Migration[5.1]
  def change
    affiliate_codes = Panelist.where.not(affiliate_code: nil).pluck(:affiliate_code).uniq
    affiliate_codes.each do |code|
      next if code.to_i.zero?

      Affiliate.find_or_create_by(code: code)
    end

    offer_codes = Panelist.where.not(offer_code: nil).pluck(:offer_code).uniq
    offer_codes.each do |code|
      next if code.to_i.zero?

      Offer.find_or_create_by(code: code)
    end
  end
end
