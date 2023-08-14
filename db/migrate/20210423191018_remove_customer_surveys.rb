# frozen_string_literal: true

# This removes the 'customer_surveys' table
class RemoveCustomerSurveys < ActiveRecord::Migration[5.2]
  def change
    drop_table :customer_surveys do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.bigint :panel_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index :panel_id, name: 'index_customer_surveys_on_panel_id'
    end
  end
end
