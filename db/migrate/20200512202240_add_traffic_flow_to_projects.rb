# frozen_string_literal: true

class AddTrafficFlowToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :traffic_flow, :string
  end
end
