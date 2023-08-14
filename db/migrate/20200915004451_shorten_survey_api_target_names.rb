# frozen_string_literal: true

class ShortenSurveyApiTargetNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :survey_api_targets, :api_filter_genders, :genders
    rename_column :survey_api_targets, :api_filter_countries, :countries
    rename_column :survey_api_targets, :api_filter_age_range, :age_range
    rename_column :survey_api_targets, :api_filter_payout_cents, :payout_cents
  end
end
