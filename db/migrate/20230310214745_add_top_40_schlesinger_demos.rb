# frozen_string_literal: true

class AddTop40SchlesingerDemos < ActiveRecord::Migration[6.1]
  def change
    SchlesingerQualificationQuestion.find_each(&:destroy)

    SyncSchlesingerQualificationsJob.perform_async
  end
end
