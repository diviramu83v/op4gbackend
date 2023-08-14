# frozen_string_literal: true

class AddCampaignToEarning < ActiveRecord::Migration[5.1]
  def change
    add_reference :earnings, :campaign, foreign_key: true
  end
end
