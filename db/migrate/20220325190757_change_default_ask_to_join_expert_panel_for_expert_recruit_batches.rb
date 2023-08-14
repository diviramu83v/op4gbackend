# frozen_string_literal: true

class ChangeDefaultAskToJoinExpertPanelForExpertRecruitBatches < ActiveRecord::Migration[5.2]
  def change
    change_column_default :expert_recruit_batches, :ask_to_join_expert_panel, from: true, to: false
  end
end
