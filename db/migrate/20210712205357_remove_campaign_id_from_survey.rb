# frozen_string_literal: true

class RemoveCampaignIdFromSurvey < ActiveRecord::Migration[5.2]
  def change
    remove_column :surveys, :campaign_id, :bigint
  end
end
