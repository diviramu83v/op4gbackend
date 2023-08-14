# frozen_string_literal: true

class AddSoftLaunchCompletesWantedToDisqoQuota < ActiveRecord::Migration[5.2]
  def change
    change_table :disqo_quotas, bulk: true do |t|
      t.integer :soft_launch_completes_wanted
      t.datetime :soft_launch_completed_at
    end
  end
end
