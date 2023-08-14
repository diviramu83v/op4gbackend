# frozen_string_literal: true

class ChangeProjectDateFieldNames < ActiveRecord::Migration[5.1]
  def change
    rename_column :projects, :start_date, :started_at
    rename_column :projects, :end_date, :finished_at
  end
end
