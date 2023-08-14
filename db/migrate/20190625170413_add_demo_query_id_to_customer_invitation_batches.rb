# frozen_string_literal: true

class AddDemoQueryIdToCustomerInvitationBatches < ActiveRecord::Migration[5.1]
  def change
    add_reference :customer_invitation_batches, :demo_query, foreign_key: true
  end
end
