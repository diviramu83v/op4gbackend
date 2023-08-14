# frozen_string_literal: true

class BackportDefaultLockFlagToRecruitingCampaigns < ActiveRecord::Migration[5.2]
  def change
    RecruitingCampaign.select(:id).find_in_batches.with_index do |records, index|
      puts "Processing batch #{index + 1}\r"
      RecruitingCampaign.where(id: records).update_all(lock_flag: false)
    end
  end
end
