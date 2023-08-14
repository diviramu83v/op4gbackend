# frozen_string_literal: true

class AddFollowUpQuestionIdsToDemoQuestions < ActiveRecord::Migration[5.2]
  safety_assured

  def change
    add_column :demo_questions, :follow_up_question_ids, :text, default: [], array: true
  end
end
