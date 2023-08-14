# frozen_string_literal: true

class AddCampaignToOnramp < ActiveRecord::Migration[5.1]
  def change
    add_reference :onramps, :campaign, foreign_key: true
  end
end
