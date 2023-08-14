# frozen_string_literal: true

class AddTrafficReports < ActiveRecord::Migration[5.1]
  def change
    create_table 'traffic_reports' do |t|
      t.string 'report_type'
      t.string 'report_file_name'
      t.string 'report_content_type'
      t.integer 'report_file_size'
      t.datetime 'report_updated_at'
      t.bigint 'campaign_id'
      t.index ['campaign_id'], name: 'index_traffic_reports_on_campaign_id'

      t.timestamps
    end
  end
end
