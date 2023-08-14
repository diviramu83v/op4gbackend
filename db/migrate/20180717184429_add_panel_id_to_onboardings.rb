# frozen_string_literal: true

class AddPanelIdToOnboardings < ActiveRecord::Migration[5.1]
  def change
    add_column :onboardings, :panel_id, :integer
  end
end
