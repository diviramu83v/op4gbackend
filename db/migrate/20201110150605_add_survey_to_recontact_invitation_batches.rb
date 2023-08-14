# frozen_string_literal: true

class AddSurveyToRecontactInvitationBatches < ActiveRecord::Migration[5.2]
  def change
    add_reference :recontact_invitation_batches, :survey, foreign_key: true
  end
end
