# frozen_string_literal: true

# Handle sending all invitations for one sample batch.
class SendBatchInvitationsJob < ApplicationJob
  queue_as :default

  def perform(sample_batch, current_employee)
    group_numbers = calculate_ordered_group_numbers(sample_batch)
    send_times = calculate_send_times(group_numbers)

    sample_batch.invitations.unsent.find_each do |invitation|
      time_to_send = send_times[invitation&.group.to_s] || Time.now.utc
      InvitationDeliveryJob.set(wait_until: time_to_send).perform_later(invitation, current_employee)
    end

    sample_batch.update sent_at: Time.now.utc
  end

  def calculate_ordered_group_numbers(batch)
    batch.invitations.pluck(:group).compact.uniq.sort
  end

  def calculate_send_times(group_numbers)
    return {} if group_numbers.empty?

    timestamp = Time.now.utc
    timestamps = [timestamp]

    (group_numbers.count - 1).times do
      timestamp += 1.hour
      timestamps << timestamp
    end

    group_numbers.zip(timestamps).to_h.transform_keys!(&:to_s)
  end
end
