# frozen_string_literal: true

class RemoveSomeSchlesingerQualificationQuestions < ActiveRecord::Migration[6.1]
  def change
    SchlesingerQualificationQuestion.destroy_all

    SyncSchlesingerQualificationsJob.perform_async
  end
end
