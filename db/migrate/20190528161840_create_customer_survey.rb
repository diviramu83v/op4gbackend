# frozen_string_literal: true

class CreateCustomerSurvey < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_surveys do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.references :panel, null: false

      t.timestamps
    end
  end
end
