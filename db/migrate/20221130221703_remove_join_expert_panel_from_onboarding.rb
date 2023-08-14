# frozen_string_literal: true

class RemoveJoinExpertPanelFromOnboarding < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :onboardings, :join_expert_panel, :boolean }
  end
end
