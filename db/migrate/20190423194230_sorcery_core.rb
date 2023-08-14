# frozen_string_literal: true

class SorceryCore < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :crypted_password, :string
    add_column :customers, :salt, :string
    add_index :customers, :email, unique: true
  end
end
