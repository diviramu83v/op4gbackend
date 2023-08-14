# frozen_string_literal: true

class AddStartDateTimeAndEndDateTimeToSchlesingerQuotas < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      change_table :schlesinger_quotas, bulk: true do |t|
        t.datetime :start_date_time
        t.datetime :end_date_time
      end
    end
  end
end
