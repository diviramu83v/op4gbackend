# frozen_string_literal: true

# This adds a status enum to the PrescreenerQuestionTemplate model
class AddStatusToPrescreenerQuestionTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :prescreener_question_templates, :status, :string
  end
end
