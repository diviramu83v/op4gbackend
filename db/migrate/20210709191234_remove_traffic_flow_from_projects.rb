# frozen_string_literal: true

class RemoveTrafficFlowFromProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :traffic_flow, :string
  end
end
