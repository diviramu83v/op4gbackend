# frozen_string_literal: true

class AddIndexesToTokenColumns < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :onramps, :token, algorithm: :concurrently, unique: true
    add_index :prescreener_questions, :token, algorithm: :concurrently, unique: true
    add_index :return_keys, :token, algorithm: :concurrently, unique: true
  end
end
