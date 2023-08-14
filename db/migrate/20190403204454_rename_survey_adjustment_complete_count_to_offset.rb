# frozen_string_literal: true

class RenameSurveyAdjustmentCompleteCountToOffset < ActiveRecord::Migration[5.1]
  def change
    rename_column :survey_adjustments, :complete_count, :offset
  end
end
