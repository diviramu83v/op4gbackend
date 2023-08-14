# frozen_string_literal: true

class AddIpAddressToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_reference :onboardings, :ip_address, foreign_key: true
  end
end
