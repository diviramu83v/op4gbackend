# frozen_string_literal: true

class AddApiTokenToOnramp < ActiveRecord::Migration[5.1]
  def change
    add_reference :onramps, :api_token, foreign_key: true
  end
end
