# frozen_string_literal: true

class AddJoinExpertPanelToOnboarding < ActiveRecord::Migration[5.2]
  def change
    add_column :onboardings, :join_expert_panel, :boolean
  end
end
