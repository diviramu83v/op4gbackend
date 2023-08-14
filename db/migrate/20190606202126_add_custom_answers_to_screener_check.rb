# frozen_string_literal: true

class AddCustomAnswersToScreenerCheck < ActiveRecord::Migration[5.1]
  def change
    add_column :screener_checks, :custom_answers, :jsonb, default: {}
  end
end
