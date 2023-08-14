# frozen_string_literal: true

class AddClientIdToDemoQueries < ActiveRecord::Migration[5.2]
  def change
    add_reference :demo_queries, :client, foreign_key: true
  end
end
