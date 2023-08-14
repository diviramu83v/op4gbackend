# frozen_string_literal: true

class AddSentAtToExpertRecruitBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :expert_recruit_batches, :sent_at, :datetime
  end
end
