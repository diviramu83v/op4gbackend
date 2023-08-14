# frozen_string_literal: true

class AddCustomParametersToClient < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :custom_uid_parameter, :string
    add_column :clients, :custom_key_parameter, :string
  end
end
