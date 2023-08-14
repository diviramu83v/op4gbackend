# frozen_string_literal: true

class CreateUnsubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :unsubscriptions do |t|
      t.string :email
      t.references :panelist, foreign_key: true, null: false

      t.timestamps
    end
  end
end
