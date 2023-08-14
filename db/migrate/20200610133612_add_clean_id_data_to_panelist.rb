# frozen_string_literal: true

class AddCleanIdDataToPanelist < ActiveRecord::Migration[5.2]
  def change
    add_column :panelists, :clean_id_data, :jsonb
  end
end
