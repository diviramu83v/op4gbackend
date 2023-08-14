# frozen_string_literal: true

class AddInvitationCountToVendorBatch < ActiveRecord::Migration[5.1]
  def change
    add_column :vendor_batches, :invitation_count, :integer
  end
end
