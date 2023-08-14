# frozen_string_literal: true

# Decodes a batch of encoded IDs.
class UidDecodingJob < ApplicationJob
  queue_as :default

  def perform(decoding)
    decoding.decode_uids
  end
end
