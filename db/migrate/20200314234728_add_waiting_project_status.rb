# frozen_string_literal: true

class AddWaitingProjectStatus < ActiveRecord::Migration[5.1]
  def up
    archived_project_status = ProjectStatus.find_by(slug: 'archived')
    if archived_project_status
      archived_project_status.sort = 6
      archived_project_status.save!
    end

    finished_project_status = ProjectStatus.find_by(slug: 'finished')
    if finished_project_status
      finished_project_status.sort = 5
      finished_project_status.save!
    end

    if archived_project_status && finished_project_status
      ProjectStatus.create(slug: 'waiting', default: false, active: true, sort: 4)
    else
      ProjectStatus.create(slug: 'waiting', default: false, active: true)
    end
  end
end
