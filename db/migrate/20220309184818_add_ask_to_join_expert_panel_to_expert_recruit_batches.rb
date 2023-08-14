# frozen_string_literal: true

class AddAskToJoinExpertPanelToExpertRecruitBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :expert_recruit_batches, :ask_to_join_expert_panel_flag, :boolean
  end
end
