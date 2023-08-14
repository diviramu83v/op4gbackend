# frozen_string_literal: true

class FillProjectInvitationTimestamps < ActiveRecord::Migration[5.1]
  def up
    now = Time.now.utc

    ProjectInvitation.where(status: 'paid', paid_at: nil).find_each do |invitation|
      invitation.update!(paid_at: invitation.project.finished_at || now)
    end

    ProjectInvitation.where(status: 'rejected', rejected_at: nil).find_each do |invitation|
      invitation.update!(rejected_at: invitation.project.finished_at || now)
    end
  end
end
