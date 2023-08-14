# frozen_string_literal: true

class SorceryRememberMe < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :remember_me_token, :string, default: nil
    add_column :customers, :remember_me_token_expires_at, :datetime, default: nil

    add_index :customers, :remember_me_token
  end
end
