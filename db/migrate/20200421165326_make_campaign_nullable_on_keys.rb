# frozen_string_literal: true

class MakeCampaignNullableOnKeys < ActiveRecord::Migration[5.2]
  def change
    change_column_null :keys, :campaign_id, true
  end
end
