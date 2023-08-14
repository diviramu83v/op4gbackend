# frozen_string_literal: true

class RemoveImportedDataFromRecruitingCampaigns < ActiveRecord::Migration[5.2]
  def change
    remove_column :recruiting_campaigns, :imported_data, :text
  end
end
