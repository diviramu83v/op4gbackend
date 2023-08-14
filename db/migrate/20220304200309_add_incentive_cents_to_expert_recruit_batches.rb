# frozen_string_literal: true

class AddIncentiveCentsToExpertRecruitBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :expert_recruit_batches, :incentive_cents, :integer
  end
end
