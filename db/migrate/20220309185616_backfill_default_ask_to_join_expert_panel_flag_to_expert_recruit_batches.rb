# frozen_string_literal: true

class BackfillDefaultAskToJoinExpertPanelFlagToExpertRecruitBatches < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/SkipsModelValidations, Rails/Output
  def change
    ExpertRecruitBatch.select(:id).find_in_batches.with_index do |records, index|
      puts "Processing batch #{index + 1}\r"
      ExpertRecruitBatch.where(id: records).update_all(ask_to_join_expert_panel_flag: true)
    end
  end
  # rubocop:enable Rails/SkipsModelValidations, Rails/Output
end
