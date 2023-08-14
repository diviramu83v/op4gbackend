# frozen_string_literal: true

# this adds a sort order column to the prescreener_answer_templates table
class AddSortOrderToPrescreenerAnswerTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :prescreener_answer_templates, :sort_order, :integer
  end
end
