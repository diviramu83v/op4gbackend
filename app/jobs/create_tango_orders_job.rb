# frozen_string_literal: true

# This job creates tango orders
class CreateTangoOrdersJob < ApplicationJob
  queue_as :default

  def perform(incentive_batch)
    incentive_batch.incentive_recipients.each do |incentive_recipient|
      body = TangoOrderData.new(incentive_recipient).order_body

      response = TangoApi.new.create_order(body: body)

      response['status'] == 'COMPLETE' ? incentive_recipient.set_to_sent : incentive_recipient.error!
    end
  end
end
