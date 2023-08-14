# frozen_string_literal: true

class ChangeOrgRoleToDecisionMaker < ActiveRecord::Migration[5.2]
  def change
    rename_column :survey_api_targets, :organization_role, :decision_maker
  end
end
