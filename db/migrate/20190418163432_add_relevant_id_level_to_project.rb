# frozen_string_literal: true

class AddRelevantIdLevelToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :relevant_id_level, :string, default: 'survey', null: false
  end
end
