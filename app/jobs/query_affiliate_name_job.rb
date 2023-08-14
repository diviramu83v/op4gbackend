# frozen_string_literal: true

# Query for affiliate name
class QueryAffiliateNameJob < ApplicationJob
  queue_as :default

  def perform(affiliate)
    affiliate.update_name_from_api
  end
end
