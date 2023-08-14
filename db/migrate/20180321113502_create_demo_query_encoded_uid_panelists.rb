# frozen_string_literal: true

class CreateDemoQueryEncodedUidPanelists < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_query_encoded_uid_panelists do |t|
      t.references :demo_query, foreign_key: true
      t.references :panelist, foreign_key: true

      t.timestamps
    end

    add_index :demo_query_encoded_uid_panelists, [:demo_query_id, :panelist_id], unique: true, name: 'index_query_encoded_uid_panelists_on_query_id_and_panelist_id'
  end
end
