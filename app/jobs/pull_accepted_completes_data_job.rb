# frozen_string_literal: true

# This job pulls accepted completes data.
class PullAcceptedCompletesDataJob < ApplicationJob
  queue_as :ui

  def perform(decoding, project) # rubocop:disable Metrics/MethodLength
    decoding.decode_uids
    html = if decoding.decoded_uids_belong_to_this_project?(project)
             decoding.update_onboardings_status('accepted')
             ApplicationController.render(
               partial: 'employee/accepted_completes/completes_data',
               locals: { decoding: decoding }
             )
           else
             ApplicationController.render(
               partial: 'employee/accepted_completes/unmatched_uids',
               locals: { decoding: decoding, project: project }
             )
           end

    AcceptedCompletesChannel.broadcast_to(decoding, html)
  end
end
