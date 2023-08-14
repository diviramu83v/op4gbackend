# frozen_string_literal: true

class RemoveNullConstraintFromDemoQuestionImportLabel < ActiveRecord::Migration[5.1]
  def change
    change_column_null :demo_questions, :import_label, true
  end
end
