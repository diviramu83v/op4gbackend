# frozen_string_literal: true

class CreateProjectSteps < ActiveRecord::Migration[5.1]
  def change
    create_table :project_steps do |t|
      t.references :project, null: false, foreign_key: true
      t.references :project_step_pattern, null: false, foreign_key: true

      t.timestamps
    end
  end
end
