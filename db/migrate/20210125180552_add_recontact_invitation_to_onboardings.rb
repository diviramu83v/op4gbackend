# frozen_string_literal: true

class AddRecontactInvitationToOnboardings < ActiveRecord::Migration[5.2]
  def change
    add_reference :onboardings, :recontact_invitation, foreign_key: true
  end
end
