# frozen_string_literal: true

class AddProjectToQuery < ActiveRecord::Migration[5.1]
  def change
    add_reference :demo_queries, :project, foreign_key: true
  end
end
