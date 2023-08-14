# frozen_string_literal: true

class AddUnemployedOptionToDemoQuestion < ActiveRecord::Migration[5.2]
  def up
    demo_question = DemoQuestion.find_by(id: 526)
    return if demo_question.blank?

    demo_question.demo_options.create(label: 'Unemployed', sort_order: 12)
    DemoOption.find(5455).update(sort_order: 13)
  end

  def down
    demo_question = DemoQuestion.find(526)
    demo_question.demo_options.find_by(label: 'Unemployed').destroy
  end
end
