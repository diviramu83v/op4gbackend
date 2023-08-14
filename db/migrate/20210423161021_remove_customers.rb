# frozen-string-literal: true

# This removes the 'customers' table
class RemoveCustomers < ActiveRecord::Migration[5.2]
  def change
    drop_table :customers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.bigint :panel_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.string :crypted_password
      t.string :salt
      t.string :reset_password_token
      t.datetime :reset_password_token_expires_at
      t.datetime :reset_password_email_sent_at
      t.integer :access_count_to_reset_password_page, default: 0
      t.string :remember_me_token
      t.datetime :remember_me_token_expires_at
      t.index :email, name: 'index_customers_on_email', unique: true
      t.index :panel_id, name: 'index_customers_on_panel_id'
      t.index :remember_me_token, name: 'index_customers_on_remember_me_token'
      t.index :reset_password_token, name: 'index_customers_on_reset_password_token'
    end
  end
end
