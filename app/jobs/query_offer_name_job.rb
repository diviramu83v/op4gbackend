# frozen_string_literal: true

# Query for offer name
class QueryOfferNameJob < ApplicationJob
  queue_as :default

  def perform(offer)
    offer.update_name_from_api
  end
end
