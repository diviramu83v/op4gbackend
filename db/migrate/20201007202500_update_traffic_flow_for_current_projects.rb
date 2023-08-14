# frozen_string_literal: true

class UpdateTrafficFlowForCurrentProjects < ActiveRecord::Migration[5.2]
  def up
    Project.where(traffic_flow: 'new').find_each do |project|
      # rubocop:disable Rails/SkipsModelValidations
      project.update_columns(traffic_flow: 'old')
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end
