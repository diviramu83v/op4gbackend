# frozen_string_literal: true

class ChangeProjectStatusToNullFalse < ActiveRecord::Migration[5.2]
  def change
    change_column_null :projects, :current_status, false
  end
end
