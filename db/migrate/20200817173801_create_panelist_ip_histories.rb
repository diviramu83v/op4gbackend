# frozen_string_literal: true

class CreatePanelistIpHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :panelist_ip_histories do |t|
      t.references :panelist, null: false
      t.references :ip_address, null: false
      t.string :source, null: false

      t.timestamps
    end
  end
end
