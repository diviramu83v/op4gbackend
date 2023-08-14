# frozen_string_literal: true

class AddInvitesCreatedAtFlag < ActiveRecord::Migration[5.1]
  def change
    add_column :sample_batches, :invitations_created_at, :datetime
  end
end
