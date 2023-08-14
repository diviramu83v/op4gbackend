# frozen_string_literal: true

class ChangeColumnNameFromQuestionToBodyOnPrescreenerQuestion < ActiveRecord::Migration[5.2]
  def change
    rename_column :prescreener_questions, :question, :body
  end
end
