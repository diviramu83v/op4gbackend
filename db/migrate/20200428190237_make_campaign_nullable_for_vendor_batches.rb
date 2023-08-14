# frozen_string_literal: true

class MakeCampaignNullableForVendorBatches < ActiveRecord::Migration[5.2]
  def change
    change_column_null :vendor_batches, :campaign_id, true
  end
end
