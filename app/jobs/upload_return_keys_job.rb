# frozen_string_literal: true

# This job adds prescreener answer templates from a file
class UploadReturnKeysJob < ApplicationJob
  queue_as :ui

  def perform(survey, number)
    ReturnKey.generate_keys(survey, number)

    ReturnKeyUploadChannel.broadcast_to(survey, 'success')
  end
end
