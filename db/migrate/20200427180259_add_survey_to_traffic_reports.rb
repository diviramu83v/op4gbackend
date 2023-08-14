# frozen_string_literal: true

class AddSurveyToTrafficReports < ActiveRecord::Migration[5.2]
  def change
    add_reference :traffic_reports, :survey, foreign_key: true
  end
end
