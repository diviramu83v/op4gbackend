# frozen_string_literal: true

class ChangeZipcodeTableName < ActiveRecord::Migration[5.1]
  def change
    rename_table :zips, :zip_codes
    rename_column :demo_query_zips, :zip_id, :zip_code_id
    rename_column :panelists, :zip_id, :zip_code_id
  end
end
