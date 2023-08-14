# frozen_string_literal: true

class AddProjectStatusesToProjectCurrentStatus < ActiveRecord::Migration[5.2]
  def change
    Project.find_each do |project|
      project.update(current_status: project.status.slug)
    end
  end
end
