# frozen_string_literal: true

class CreateRedirectLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :redirect_logs do |t|
      t.text :url
      t.references :survey_response_url, index: true, foreign_key: true

      t.timestamps
    end
  end
end
