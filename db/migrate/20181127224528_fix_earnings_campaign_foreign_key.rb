# frozen_string_literal: true

class FixEarningsCampaignForeignKey < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :earnings, :campaigns

    add_foreign_key :earnings, :recruiting_campaigns, column: :campaign_id
  end
end
