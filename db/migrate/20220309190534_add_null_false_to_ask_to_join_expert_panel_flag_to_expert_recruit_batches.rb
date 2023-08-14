# frozen_string_literal: true

class AddNullFalseToAskToJoinExpertPanelFlagToExpertRecruitBatches < ActiveRecord::Migration[5.2]
  def change
    change_column_null :expert_recruit_batches, :ask_to_join_expert_panel_flag, false
  end
end
