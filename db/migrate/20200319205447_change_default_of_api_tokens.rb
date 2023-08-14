# frozen_string_literal: true

class ChangeDefaultOfApiTokens < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:api_tokens, :status, from: 'active', to: 'sandbox')
  end
end
