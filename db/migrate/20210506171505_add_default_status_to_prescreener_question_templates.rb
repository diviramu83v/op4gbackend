# frozen_string_literal: true

# This adds a default status to the PrescreenerQuestionTemplate model
class AddDefaultStatusToPrescreenerQuestionTemplates < ActiveRecord::Migration[5.2]
  def change
    change_column_default :prescreener_question_templates, :status, from: nil, to: 'active'
  end
end
