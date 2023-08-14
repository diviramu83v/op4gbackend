# frozen_string_literal: true

class MakeProjectNotRequiredOnKeys < ActiveRecord::Migration[5.1]
  def change
    change_column_null :keys, :project_id, true
  end
end
