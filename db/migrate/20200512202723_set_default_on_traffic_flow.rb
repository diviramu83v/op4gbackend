# frozen_string_literal: true

class SetDefaultOnTrafficFlow < ActiveRecord::Migration[5.2]
  safety_assured
  # rubocop:disable Rails/SkipsModelValidations
  def up
    Project.find_each do |project|
      project.update_column(:traffic_flow, Project.traffic_flows[:old])
    end
    change_column :projects, :traffic_flow, :string, default: Project.traffic_flows[:old], null: false
  end
  # rubocop:enable Rails/SkipsModelValidations

  def down
    change_column :projects, :traffic_flow, :string
  end
end
