# frozen_string_literal: true

class AddStatusToCustomerInvitations < ActiveRecord::Migration[5.1]
  def change
    add_column :customer_invitation_batches, :status, :string, null: false, default: 'initialized'
    add_column :customer_survey_invitations, :status, :string, null: false, default: 'initialized'
  end
end
