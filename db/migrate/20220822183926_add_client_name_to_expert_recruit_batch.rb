# frozen_string_literal: true

class AddClientNameToExpertRecruitBatch < ActiveRecord::Migration[6.1]
  def change
    add_column :expert_recruit_batches, :client_name, :string
  end
end
