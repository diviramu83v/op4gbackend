# frozen_string_literal: true

class ChangeColumnNullOnRedirectLogs < ActiveRecord::Migration[5.2]
  def change
    change_column_null :redirect_logs, :url, false
    change_column_null :redirect_logs, :survey_response_url_id, false
  end
end
