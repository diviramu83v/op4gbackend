# frozen_string_literal: true

# This job creates incentive recipients
class CreateIncentiveRecipientsJob < ApplicationJob
  queue_as :ui

  def perform(batch)
    sleep(2)
    JSON.parse(batch.csv_data).each do |email, values|
      batch.incentive_recipients.create!(email_address: email, first_name: values[0], last_name: values[1])
    end

    CreateIncentiveRecipientsChannel.broadcast_to('all', { batch_id: batch.id, recipient_count: batch.incentive_recipients.count })
  end
end
