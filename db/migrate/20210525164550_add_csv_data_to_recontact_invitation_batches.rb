# frozen_string_literal: true

class AddCsvDataToRecontactInvitationBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :recontact_invitation_batches, :csv_data, :text
  end
end
