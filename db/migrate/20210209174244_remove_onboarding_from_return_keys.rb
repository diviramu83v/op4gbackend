# frozen_string_literal: true

class RemoveOnboardingFromReturnKeys < ActiveRecord::Migration[5.2]
  def change
    remove_reference :return_keys, :onboarding, foreign_key: true
  end
end
