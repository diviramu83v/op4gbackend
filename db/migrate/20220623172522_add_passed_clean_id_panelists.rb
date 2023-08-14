# frozen_string_literal: true

class AddPassedCleanIdPanelists < ActiveRecord::Migration[6.1]
  def change
    add_column :panelists, :passed_clean_id_previous_version, :boolean
  end
end
