# frozen_string_literal: true

class CreateClientSentUnsubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :client_sent_unsubscriptions do |t|
      t.string :email
      t.references :client_sent_survey_invitation, index: { name: 'index_client_unsubscription_on_client_sent_survey_invitation_id' }

      t.timestamps
    end
  end
end
