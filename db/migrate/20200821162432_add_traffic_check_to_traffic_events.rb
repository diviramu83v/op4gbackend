# frozen_string_literal: true

class AddTrafficCheckToTrafficEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :traffic_events, :traffic_check, foreign_key: true
  end
end
