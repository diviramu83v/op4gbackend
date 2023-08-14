# frozen_string_literal: true

class UpdateInvitationStatus < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!
  safety_assured

  # rubocop:disable Rails/SkipsModelValidations, Metrics/BlockNesting
  def up
    ProjectInvitation.where(status: nil).find_each do |invitation|
      if invitation.sent_at.present?
        if invitation.declined_at.present?
          invitation.update_column(:status, 'declined')
        elsif invitation.clicked_at.present?
          if invitation.finished_at.present?
            if Earning.where(panelist: invitation.panelist, sample_batch: invitation.batch).any?
              invitation.update_column(:status, 'paid')
            elsif %w[finished archived].include?(invitation.project.status.slug)
              invitation.update_column(:status, 'rejected')
            else
              invitation.update_column(:status, 'finished')
            end
          else
            invitation.update_column(:status, 'clicked')
          end
        else
          invitation.update_column(:status, 'sent')
        end
      else
        invitation.update_column(:status, 'initialized')
      end
    end
  end
  # rubocop:enable Rails/SkipsModelValidations, Metrics/BlockNesting

  # rubocop:disable Rails/SkipsModelValidations
  def down
    ProjectInvitation.update_all(status: nil)
  end
  # rubocop:enable Rails/SkipsModelValidations
end
