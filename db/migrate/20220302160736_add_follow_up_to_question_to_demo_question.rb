# frozen_string_literal: true

class AddFollowUpToQuestionToDemoQuestion < ActiveRecord::Migration[5.2]
  def change
    add_reference :demo_questions, :follow_up_to_question, foreign_key: { to_table: :demo_questions }
  end
end
