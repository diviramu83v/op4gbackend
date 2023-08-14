# frozen_string_literal: true

class AddFollowUpsToQuestion < ActiveRecord::Migration[5.2]
  def change
    demo_question = DemoQuestion.find_by(label: 'industry')
    follow_up = DemoQuestion.find_by(label: 'profession')
    demo_question.update_column(:follow_up_question_ids, [follow_up.id]) # rubocop:disable Rails/SkipsModelValidations
  end
end
