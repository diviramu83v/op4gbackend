# frozen_string_literal: true

class AddCleanIdDataDefaultToPanelists < ActiveRecord::Migration[5.2]
  def change
    change_column :panelists, :clean_id_data, :jsonb, default: {}
  end
end
