# frozen_string_literal: true

class MoveOldInvitationsToIgnored < ActiveRecord::Migration[5.2]
  def change
    safety_assured do
      ignored_invitations = ProjectInvitation.joins(:onboarding)
                                             .where('project_invitations.status IN (?)', %w[paid rejected])
                                             .where.not('onboardings.survey_response_pattern_id = ?', 1)

      ignored_invitations.find_each do |invitation|
        invitation.update!(status: 'ignored')
      end
    end
  end
end
