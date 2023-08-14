# frozen_string_literal: true

class RenameNameToCintIdOnCintSurveys < ActiveRecord::Migration[6.1]
  def change
    rename_column :cint_surveys, :name, :cint_id
  end
end
