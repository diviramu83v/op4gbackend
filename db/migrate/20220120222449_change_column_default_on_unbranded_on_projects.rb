# frozen_string_literal: true

class ChangeColumnDefaultOnUnbrandedOnProjects < ActiveRecord::Migration[5.2]
  def change
    change_column_default :projects, :unbranded, from: nil, to: false
    change_column_null :projects, :unbranded, false
  end
end
