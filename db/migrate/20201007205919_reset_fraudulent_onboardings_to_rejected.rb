# frozen_string_literal: true

class ResetFraudulentOnboardingsToRejected < ActiveRecord::Migration[5.2]
  def up
    Onboarding.fraudulent.find_each(&:rejected!)
  end
end
