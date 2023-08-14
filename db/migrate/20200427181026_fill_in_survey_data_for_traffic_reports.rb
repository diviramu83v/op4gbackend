# frozen_string_literal: true

class FillInSurveyDataForTrafficReports < ActiveRecord::Migration[5.2]
  def change
    TrafficReport.find_each do |traffic_report|
      traffic_report.update(survey_id: traffic_report.campaign.survey.id)
    end
  end
end
