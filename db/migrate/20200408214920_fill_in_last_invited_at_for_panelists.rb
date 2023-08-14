# frozen_string_literal: true

class FillInLastInvitedAtForPanelists < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  safety_assured do
    def change
      Panelist.where(last_invited_at: nil).find_each do |panelist|
        next if panelist.invitations.has_been_sent.blank?

        latest_date = panelist.invitations.has_been_sent.maximum(:sent_at)
        # rubocop:disable Rails/SkipsModelValidations
        panelist.update_column(:last_invited_at, latest_date)
        # rubocop:enable Rails/SkipsModelValidations
      end
    end
  end
end
