# frozen_string_literal: true

class AddManagerToProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :manager, foreign_key: { to_table: :employees }
  end
end
