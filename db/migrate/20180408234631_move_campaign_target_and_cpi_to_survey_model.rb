# frozen_string_literal: true

class MoveCampaignTargetAndCpiToSurveyModel < ActiveRecord::Migration[5.1]
  def change
    remove_column :campaigns, :target, :integer
    remove_column :campaigns, :cpi_cents, :integer

    add_column :surveys, :target, :integer
    add_column :surveys, :cpi_cents, :integer
  end
end
