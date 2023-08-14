# frozen_string_literal: true

# This job destroys keys
class DestroyKeysJob < ApplicationJob
  queue_as :default

  def perform(survey)
    survey.keys.unused.destroy_all
  end
end
