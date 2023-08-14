# frozen_string_literal: true

class RenameProjectSalespersonColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :projects, :temporary_salesperson_id, :salesperson_id
  end
end
