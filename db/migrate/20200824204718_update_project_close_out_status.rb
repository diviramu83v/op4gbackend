# frozen_string_literal: true

class UpdateProjectCloseOutStatus < ActiveRecord::Migration[5.2]
  def change
    Project.finished.where('finished_at > ?', ENV.fetch('PROJECT_CLOSE_OUT_DATE'))
           .or(Project.waiting.where('waiting_at > ?', ENV.fetch('PROJECT_CLOSE_OUT_DATE'))).find_each do |project|
             next unless project.waiting?
             next if project.onboardings.where(client_status: nil).count == project.onboardings.count

             project.update(close_out_status: 'frauds_recorded') if frauds_recorded_but_no_completes?(project)
             project.update(close_out_status: 'completes_recorded') if completes_recorded?(project)
           end
  end

  def frauds_recorded_but_no_completes?(project)
    project.onboardings.where(client_status: 'fraudulent').present?
    project.onboardings.where(client_status: 'accepted').blank?
  end

  def completes_recorded?(project)
    project.onboardings.where(client_status: 'accepted').present?
  end
end
