# frozen_string_literal: true

class ChangeColumnNullOnProjectCloseOutStatus < ActiveRecord::Migration[5.2]
  def change
    change_column_null :projects, :close_out_status, false
  end
end
