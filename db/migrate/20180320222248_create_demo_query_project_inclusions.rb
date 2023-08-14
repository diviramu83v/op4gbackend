# frozen_string_literal: true

class CreateDemoQueryProjectInclusions < ActiveRecord::Migration[5.1]
  def change
    create_table :demo_query_project_inclusions do |t|
      t.references :demo_query, foreign_key: true, null: false
      t.references :project, foreign_key: true, null: false
      t.references :survey_response_pattern, foreign_key: true, index: { name: 'index_project_inclusion_survey_response' }

      t.timestamps
    end
  end
end
