# frozen_string_literal: true

class AddFailedQuestionsToScreenerCheck < ActiveRecord::Migration[5.1]
  def change
    add_column :screener_checks, :failed_questions, :string, default: [], array: true
  end
end
