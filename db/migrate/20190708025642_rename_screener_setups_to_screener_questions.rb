# frozen_string_literal: true

class RenameScreenerSetupsToScreenerQuestions < ActiveRecord::Migration[5.1]
  def change
    rename_table :screener_setups, :screener_questions
  end
end
