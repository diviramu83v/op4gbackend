# frozen_string_literal: true

class AddProjectValueIndexToKeys < ActiveRecord::Migration[5.1]
  def change
    add_index :keys, [:project_id, :value], unique: true
  end
end
