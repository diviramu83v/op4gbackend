# frozen_string_literal: true

class CreateEmployeeIpHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_ip_histories do |t|
      t.references :employee, null: false
      t.references :ip_address, null: false

      t.timestamps
    end
  end
end
