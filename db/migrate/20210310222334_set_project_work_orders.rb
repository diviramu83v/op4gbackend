# frozen_string_literal: true

# This migration sets all of the nil work_orders to 0
class SetProjectWorkOrders < ActiveRecord::Migration[5.2]
  def change
    Project.finished.where(work_order: nil).find_each do |project|
      project.update(work_order: 0)
    end
  end
end
