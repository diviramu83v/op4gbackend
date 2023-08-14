# frozen_string_literal: true

class IndexCompletesDecodersOnEmployeeId < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :completes_decoders, :employee_id, algorithm: :concurrently
  end
end
