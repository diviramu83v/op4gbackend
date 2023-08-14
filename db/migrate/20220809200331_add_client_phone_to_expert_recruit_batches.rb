# frozen_string_literal: true

class AddClientPhoneToExpertRecruitBatches < ActiveRecord::Migration[6.1]
  def change
    add_column :expert_recruit_batches, :client_phone, :string
  end
end
