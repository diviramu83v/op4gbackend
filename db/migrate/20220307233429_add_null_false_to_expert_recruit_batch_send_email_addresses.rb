# frozen_string_literal: true

class AddNullFalseToExpertRecruitBatchSendEmailAddresses < ActiveRecord::Migration[5.2]
  def change
    change_column_null :expert_recruit_batches, :send_email_address, false
  end
end
