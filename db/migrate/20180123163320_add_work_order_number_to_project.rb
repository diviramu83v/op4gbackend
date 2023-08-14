# frozen_string_literal: true

class AddWorkOrderNumberToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :work_order, :integer
  end
end
