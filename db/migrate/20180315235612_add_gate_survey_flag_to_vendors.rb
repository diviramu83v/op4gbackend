# frozen_string_literal: true

class AddGateSurveyFlagToVendors < ActiveRecord::Migration[5.1]
  def change
    add_column :vendors, :gate_survey_on_by_default, :boolean, null: false, default: false
  end
end
