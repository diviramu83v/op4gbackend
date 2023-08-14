# frozen_string_literal: true

class UpdateTrafficFlowDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :projects, :traffic_flow, from: 'new', to: 'old'
  end
end
