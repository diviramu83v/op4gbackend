# frozen_string_literal: true

class AddDefaultAskToJoinExpertPanelToExpertRecruitBatches < ActiveRecord::Migration[5.2]
  def change
    change_column_default :expert_recruit_batches, :ask_to_join_expert_panel_flag, from: false, to: true
  end
end
