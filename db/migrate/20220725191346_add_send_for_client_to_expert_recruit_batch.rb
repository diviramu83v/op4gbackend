# frozen_string_literal: true

class AddSendForClientToExpertRecruitBatch < ActiveRecord::Migration[6.1]
  def up
    add_column :expert_recruit_batches, :send_for_client, :boolean
    change_column_default :expert_recruit_batches, :send_for_client, false
  end

  def down
    remove_column :expert_recruit_batches, :send_for_client
  end
end
