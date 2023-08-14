# frozen_string_literal: true

class AddUrlToTrafficEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :traffic_events, :url, :string
  end
end
