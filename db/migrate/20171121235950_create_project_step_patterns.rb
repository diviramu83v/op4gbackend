# frozen_string_literal: true

class CreateProjectStepPatterns < ActiveRecord::Migration[5.1]
  def change
    create_table :project_step_patterns do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
