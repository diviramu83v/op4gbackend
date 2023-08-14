# frozen_string_literal: true

class TurnOnNewTrafficFlowByDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :projects, :traffic_flow, from: 'old', to: 'new'
  end
end
