# frozen_string_literal: true

class AddIndexToTestUids < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :test_uids, [:onramp_id, :employee_id, :uid], algorithm: :concurrently, unique: true
  end
end
