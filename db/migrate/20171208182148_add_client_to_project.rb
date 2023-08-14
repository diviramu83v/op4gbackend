# frozen_string_literal: true

class AddClientToProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :client, foreign_key: true
  end
end
