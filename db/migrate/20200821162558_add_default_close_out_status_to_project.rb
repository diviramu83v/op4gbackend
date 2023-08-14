# frozen_string_literal: true

class AddDefaultCloseOutStatusToProject < ActiveRecord::Migration[5.2]
  def change
    change_column_default :projects, :close_out_status, from: nil, to: 'waiting'
  end
end
