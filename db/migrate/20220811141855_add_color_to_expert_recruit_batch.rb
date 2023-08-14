# frozen_string_literal: true

class AddColorToExpertRecruitBatch < ActiveRecord::Migration[6.1]
  def change
    add_column :expert_recruit_batches, :color, :string
  end
end
