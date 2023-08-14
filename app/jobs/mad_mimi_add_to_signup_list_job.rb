# frozen_string_literal: true

# Adds a panelist to a list in Mad Mimi to trigger a new signup drip campaign.
class MadMimiAddToSignupListJob < ApplicationJob
  queue_as :background

  def perform(panelist:)
    panelist.add_to_signup_list
  end
end
