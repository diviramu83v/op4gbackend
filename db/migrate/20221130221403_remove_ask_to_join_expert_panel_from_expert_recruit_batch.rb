# frozen_string_literal: true

class RemoveAskToJoinExpertPanelFromExpertRecruitBatch < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :expert_recruit_batches, :ask_to_join_expert_panel, :boolean }
  end
end
