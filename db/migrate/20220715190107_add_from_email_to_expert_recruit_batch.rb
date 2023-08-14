# frozen_string_literal: true

class AddFromEmailToExpertRecruitBatch < ActiveRecord::Migration[6.1]
  def change
    add_column :expert_recruit_batches, :from_email, :string
  end
end
