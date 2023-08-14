# frozen_string_literal: true

class DropPodsTable < ActiveRecord::Migration[6.1]
  def up
    safety_assured do
      Employee.where.not(pod_id: nil).find_each do |employee|
        employee.update(pod_id: nil)
      end
      remove_reference :employees, :pod
      drop_table :pods
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
