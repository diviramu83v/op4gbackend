# frozen_string_literal: true

class AddWorkOrderToProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :work_order, foreign_key: true
  end
end
