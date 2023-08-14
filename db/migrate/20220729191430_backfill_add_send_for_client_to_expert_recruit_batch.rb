# frozen_string_literal: true

class BackfillAddSendForClientToExpertRecruitBatch < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    ExpertRecruitBatch.unscoped.in_batches do |relation|
      relation.update_all send_for_client: false
      sleep(0.01)
    end
  end
end
