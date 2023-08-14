# frozen_string_literal: true

class MakeCampaignOptionalOnSurvey < ActiveRecord::Migration[5.2]
  def change
    change_column_null :surveys, :campaign_id, true
  end
end
