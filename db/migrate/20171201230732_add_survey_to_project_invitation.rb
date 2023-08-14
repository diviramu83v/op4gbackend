# frozen_string_literal: true

class AddSurveyToProjectInvitation < ActiveRecord::Migration[5.1]
  def change
    add_reference :project_invitations, :survey, foreign_key: true, null: false
  end
end
