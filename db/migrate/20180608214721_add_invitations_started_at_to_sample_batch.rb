# frozen_string_literal: true

class AddInvitationsStartedAtToSampleBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :sample_batches, :invitations_started_at, :datetime
  end
end
