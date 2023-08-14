# frozen_string_literal: true

class AddInvitationToOnboarding < ActiveRecord::Migration[5.1]
  def change
    add_reference :onboardings, :project_invitation, foreign_key: true
  end
end
