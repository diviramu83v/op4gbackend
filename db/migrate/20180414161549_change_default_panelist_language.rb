# frozen_string_literal: true

class ChangeDefaultPanelistLanguage < ActiveRecord::Migration[5.1]
  def up
    change_column_default :panelists, :language, 'en'
  end

  def down
    change_column_default :panelists, :language, 'english'
  end
end
