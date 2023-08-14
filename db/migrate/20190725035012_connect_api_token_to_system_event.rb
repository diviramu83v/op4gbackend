# frozen_string_literal: true

class ConnectApiTokenToSystemEvent < ActiveRecord::Migration[5.1]
  def change
    add_reference :system_events, :api_token, index: true, foreign_key: true
  end
end
