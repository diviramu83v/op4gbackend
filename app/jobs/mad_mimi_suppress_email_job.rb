# frozen_string_literal: true

# Prevents any further Mad Mimi communication with a specific email address.
class MadMimiSuppressEmailJob < ApplicationJob
  queue_as :background

  def perform(email:)
    MadMimiApi.new.suppress_all_communication(email: email) unless email.include?('deleted')
  end
end
