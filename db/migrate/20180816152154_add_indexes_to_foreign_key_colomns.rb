# frozen_string_literal: true

class AddIndexesToForeignKeyColomns < ActiveRecord::Migration[5.1]
  def change
    add_index :surveys, :router_id
    add_index :onramps, :survey_router_id
  end
end
