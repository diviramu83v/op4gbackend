# frozen_string_literal: true

class AddDefaultToCheckCleanId < ActiveRecord::Migration[5.2]
  def up
    change_column :onramps, :check_clean_id, :boolean, default: false, null: false
  end
end
