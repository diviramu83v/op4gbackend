# frozen_string_literal: true

class CreatePodsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :pods do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
