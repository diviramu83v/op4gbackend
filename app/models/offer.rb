# frozen_string_literal: true

# These are offers
class Offer < ApplicationRecord
  validates :code, presence: true

  has_many :panelists, primary_key: 'code', foreign_key: 'offer_code', inverse_of: :offer, dependent: :restrict_with_exception
  has_many :conversions, dependent: :destroy

  after_create :start_query_offer_name_job

  def start_query_offer_name_job
    QueryOfferNameJob.perform_later(self)
  end

  def update_name_from_api
    @tune_api = TuneApi.new
    offer_name = @tune_api.query_offer_name(code: code)
    update!(name: offer_name)
  end

  def code_and_name
    "#{code}: #{name}"
  end
end
