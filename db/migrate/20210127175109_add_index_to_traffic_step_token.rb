# frozen_string_literal: true

class AddIndexToTrafficStepToken < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    add_index :traffic_steps, :token, algorithm: :concurrently, unique: true
  end
end
