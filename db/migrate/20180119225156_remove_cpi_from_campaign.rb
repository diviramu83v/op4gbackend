# frozen_string_literal: true

class RemoveCpiFromCampaign < ActiveRecord::Migration[5.1]
  def change
    remove_column :campaigns, :cpi, :integer
  end
end
