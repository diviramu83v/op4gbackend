# frozen_string_literal: true

class AddCloseOutStatusToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :close_out_status, :string
  end
end
