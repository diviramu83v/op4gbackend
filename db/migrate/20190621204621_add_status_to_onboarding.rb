# frozen_string_literal: true

class AddStatusToOnboarding < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def change
    add_column :onboardings, :status, :integer, null: false, default: 0
  end
end
