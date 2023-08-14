# frozen_string_literal: true

class AddSendEmailAddressToExpertRecruitBatches < ActiveRecord::Migration[5.2]
  def change
    add_column :expert_recruit_batches, :send_email_address, :string
  end
end
