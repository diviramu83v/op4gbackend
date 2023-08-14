# frozen_string_literal: true

class AddFailedToPrescreenerQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :prescreener_questions, :failed, :boolean
  end
end
