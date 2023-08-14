# frozen_string_literal: true

class AddArchivedAtToDemoQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :demo_questions, :archived_at, :timestamp
  end
end
