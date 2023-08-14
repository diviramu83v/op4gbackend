# frozen_string_literal: true

# A conversion is recorded on the HasOffers/TUNE system when someone finishes
#   signing up. We're recording some of that data here for easy access.
class Conversion < ApplicationRecord
  belongs_to :offer
  belongs_to :affiliate

  validates :tune_code, :payout_cents, presence: true
  validates :tune_code, uniqueness: true

  def self.process_new_conversions(offer_code)
    @tune_api = TuneApi.new
    @tune_api.find_new_conversions_for_offer(offer_code).each do |conversion|
      offer = Offer.find_or_create_by(code: conversion['offer_id'])
      affiliate = Affiliate.find_or_create_by(code: conversion['affiliate_id'])
      payout = conversion['payout'].to_i * 100

      Conversion.create!(offer: offer, affiliate: affiliate, tune_code: conversion['tune_event_id'],
                         payout_cents: payout, tune_created_at: conversion['datetime'])
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
      next
    end
  end
end
