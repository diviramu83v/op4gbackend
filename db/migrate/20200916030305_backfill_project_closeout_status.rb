# frozen_string_literal: true

class BackfillProjectCloseoutStatus < ActiveRecord::Migration[5.2]
  def up
    Project.finished.where(close_out_status: 'completes_recorded').find_each(&:finalized!)
  end
end
