# frozen_string_literal: true

class RemovePanelFromDemoQuestion < ActiveRecord::Migration[5.1]
  def change
    remove_column :demo_questions, :panel_id, :integer
  end
end
