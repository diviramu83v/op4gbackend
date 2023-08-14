# frozen_string_literal: true

class CreateRecontacts < ActiveRecord::Migration[5.2]
  def change
    create_table :recontacts do |t|
      t.string :name, null: false
      t.references :project, null: false

      t.timestamps
    end
  end
end
