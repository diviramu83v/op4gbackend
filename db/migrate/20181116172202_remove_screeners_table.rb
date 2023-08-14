# frozen_string_literal: true

class RemoveScreenersTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :screeners
  end
end
