# frozen_string_literal: true

class RenameAskToJoinExpertPanelFlagToAskToJoinExpertPanelOnExpertRecruitBatches < ActiveRecord::Migration[5.2]
  def change
    rename_column :expert_recruit_batches, :ask_to_join_expert_panel_flag, :ask_to_join_expert_panel
  end
end
