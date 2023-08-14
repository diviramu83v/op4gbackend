# frozen_string_literal: true

class MakeOnboardingTokenForOnboardingRecordNotNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null(:onboardings, :onboarding_token, false)
  end
end
