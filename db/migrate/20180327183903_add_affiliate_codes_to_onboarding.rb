# frozen_string_literal: true

class AddAffiliateCodesToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :affiliate_code, :string
    add_column :onboardings, :sub_affiliate_code, :string
  end
end
