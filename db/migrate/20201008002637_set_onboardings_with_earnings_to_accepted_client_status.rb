# frozen_string_literal: true

class SetOnboardingsWithEarningsToAcceptedClientStatus < ActiveRecord::Migration[5.2]
  def up
    Onboarding.with_earnings.find_each(&:accepted!)
  end
end
