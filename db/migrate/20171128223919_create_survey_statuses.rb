# frozen_string_literal: true

class CreateSurveyStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :survey_statuses do |t|
      t.string :slug, null: false

      t.timestamps
    end

    add_index :survey_statuses, :slug, unique: true
  end
end
