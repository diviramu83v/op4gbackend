# frozen_string_literal: true

class RemoveOldKeys < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def up
    Project.delete_old_keys
  end
end
