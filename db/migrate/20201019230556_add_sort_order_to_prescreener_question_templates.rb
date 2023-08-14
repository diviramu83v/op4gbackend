# frozen_string_literal: true

class AddSortOrderToPrescreenerQuestionTemplates < ActiveRecord::Migration[5.2]
  def change
    add_column :prescreener_question_templates, :sort_order, :integer
  end
end
