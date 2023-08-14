# frozen_string_literal: true

# this gives a sort order number to all existing prescreener answer templates
class BackportSortOrderToPrescreenerAnswers < ActiveRecord::Migration[5.2]
  def change
    PrescreenerQuestionTemplate.find_each do |question|
      question.prescreener_answer_templates.find_each.with_index do |answer, index|
        answer.update(sort_order: index)
      end
    end
  end
end
