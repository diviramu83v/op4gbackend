# frozen_string_literal: true

class AddLogoToNonprofitAndCampaignAudiences < ActiveRecord::Migration[5.1]
  def change
    add_attachment :campaign_audiences, :logo
    add_attachment :nonprofits, :logo
  end
end
