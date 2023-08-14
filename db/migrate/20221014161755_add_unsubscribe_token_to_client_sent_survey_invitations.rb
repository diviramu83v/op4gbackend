# frozen_string_literal: true

class AddUnsubscribeTokenToClientSentSurveyInvitations < ActiveRecord::Migration[6.1]
  def change
    add_column :client_sent_survey_invitations, :unsubscribe_token, :string
  end
end
