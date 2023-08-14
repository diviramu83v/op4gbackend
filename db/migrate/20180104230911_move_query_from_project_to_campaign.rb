# frozen_string_literal: true

class MoveQueryFromProjectToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_reference :demo_queries, :campaign, foreign_key: true
    remove_column :demo_queries, :project_id, :integer
  end
end
