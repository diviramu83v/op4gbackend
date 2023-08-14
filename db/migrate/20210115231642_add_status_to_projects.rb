# frozen_string_literal: true

class AddStatusToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :current_status, :string
  end
end
