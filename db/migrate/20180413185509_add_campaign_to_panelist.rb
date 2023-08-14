# frozen_string_literal: true

class AddCampaignToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_reference :panelists, :campaign, foreign_key: { to_table: :recruiting_campaigns }
  end
end
