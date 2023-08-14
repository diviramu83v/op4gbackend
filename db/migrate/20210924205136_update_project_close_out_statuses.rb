# frozen_string_literal: true

class UpdateProjectCloseOutStatuses < ActiveRecord::Migration[5.2]
  def change
    projects = Project.where(close_out_status: 'frauds_recorded')
                      .or(Project.where(close_out_status: 'completes_recorded'))
                      .or(Project.where(close_out_status: 'earnings_recorded'))

    safety_assured do
      projects.each do |project|
        next if project.waiting_on_close_out? || project.finalized?

        project.waiting_on_close_out!
      end
    end
  end
end
