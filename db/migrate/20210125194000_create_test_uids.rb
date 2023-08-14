# frozen_string_literal: true

class CreateTestUids < ActiveRecord::Migration[5.2]
  def change
    create_table :test_uids do |t|
      t.references :onramp
      t.references :employee
      t.string :uid

      t.timestamps
    end
  end
end
