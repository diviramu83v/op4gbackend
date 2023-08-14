# frozen_string_literal: true

class AddTimestampsToSurvey < ActiveRecord::Migration[5.2]
  def change
    change_table :surveys, bulk: true do |t|
      t.datetime :finished_at
      t.datetime :started_at
      t.datetime :waiting_at
    end
  end
end
