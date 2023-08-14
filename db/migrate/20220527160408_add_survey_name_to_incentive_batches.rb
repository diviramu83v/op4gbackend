# frozen_string_literal: true

class AddSurveyNameToIncentiveBatches < ActiveRecord::Migration[6.0]
  def change
    add_column :incentive_batches, :survey_name, :string
  end
end
