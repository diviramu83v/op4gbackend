# frozen_string_literal: true

class AddExpertRecruitmentBatchReferenceToExpertRecruit < ActiveRecord::Migration[5.2]
  def change
    add_reference :expert_recruits, :expert_recruit_batch, foreign_key: true
  end
end
