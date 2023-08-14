# frozen_string_literal: true

class AddDefaultStatusToProjects < ActiveRecord::Migration[5.2]
  def change
    change_column_default :projects, :current_status, from: nil, to: 'draft'
  end
end
