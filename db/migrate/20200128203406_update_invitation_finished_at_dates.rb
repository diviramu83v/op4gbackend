# frozen_string_literal: true

# rubocop:disable Rails/SkipsModelValidations
class UpdateInvitationFinishedAtDates < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!
  safety_assured

  def up
    # add temporary column
    add_column :project_invitations, :tmp_finished_at, :datetime

    # copy old finished timestamp data
    ProjectInvitation.where.not(finished_at: nil).find_each do |invitation|
      invitation.update_columns(tmp_finished_at: invitation.finished_at)
    end

    # remove incorrect finished timestamps
    ProjectInvitation.where.not(finished_at: nil).find_each do |invitation|
      invitation.update_columns(finished_at: nil)
    end

    # update finished timestamp from onboarding table
    Onboarding.survey_finished.where.not(project_invitation: nil).find_each do |onboarding|
      next if onboarding.project_invitation.nil?

      onboarding.project_invitation.update_columns(finished_at: onboarding.survey_finished_at)
    end
  end

  def down
    # copy old data back over
    ProjectInvitation.find_each do |invitation|
      invitation.update_columns(finished_at: invitation.tmp_finished_at)
    end

    # remove temporary column
    drop_column :project_invitations, :tmp_finished_at
  end
end
# rubocop:enable Rails/SkipsModelValidations
