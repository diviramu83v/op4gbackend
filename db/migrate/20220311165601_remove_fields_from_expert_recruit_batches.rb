# frozen_string_literal: true

class RemoveFieldsFromExpertRecruitBatches < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/BulkChangeTable
  def change
    remove_column :expert_recruit_batches, :send_email_address, :string
    remove_column :expert_recruit_batches, :email_wording, :string
  end
  # rubocop:enable Rails/BulkChangeTable
end
