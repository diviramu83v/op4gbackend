# frozen_string_literal: true

class AddOnrampUidIndexToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_index :onboardings, [:onramp_id, :uid], unique: true
  end
end
