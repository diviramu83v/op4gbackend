# frozen_string_literal: true

class AddSurveyToEarningsBatch < ActiveRecord::Migration[5.1]
  def change
    add_reference :earnings_batches, :survey, null: false, foreign_key: true
  end
end
