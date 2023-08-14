# frozen_string_literal: true

class ChangePanelistLanguageColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :panelists, :language, :locale
  end
end
