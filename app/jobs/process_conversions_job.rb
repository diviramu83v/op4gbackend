# frozen_string_literal: true

# process new conversions
class ProcessConversionsJob < ApplicationJob
  queue_as :default

  def perform(offer_code)
    Conversion.process_new_conversions(offer_code)
  end
end
