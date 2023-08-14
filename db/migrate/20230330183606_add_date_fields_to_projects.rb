class AddDateFieldsToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :estimated_start_date, :date
    add_column :projects, :estimated_complete_date, :date
    add_column :projects, :start_date, :date
    add_column :projects, :complete_date, :date
  end
end
