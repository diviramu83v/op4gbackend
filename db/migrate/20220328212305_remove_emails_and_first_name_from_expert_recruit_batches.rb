# frozen_string_literal: true

class RemoveEmailsAndFirstNameFromExpertRecruitBatches < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/BulkChangeTable
  def change
    remove_column :expert_recruit_batches, :emails, :string
    remove_column :expert_recruit_batches, :first_name, :string
  end
  # rubocop:enable Rails/BulkChangeTable
end
