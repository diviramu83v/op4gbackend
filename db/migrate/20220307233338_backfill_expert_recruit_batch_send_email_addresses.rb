# frozen_string_literal: true

class BackfillExpertRecruitBatchSendEmailAddresses < ActiveRecord::Migration[5.2]
  def change
    ExpertRecruitBatch.find_each do |batch|
      batch.update_column(:send_email_address, 'support@op4g.com') if batch.send_email_address.blank? # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
