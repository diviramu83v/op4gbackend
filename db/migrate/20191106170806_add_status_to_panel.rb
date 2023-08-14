# frozen_string_literal: true

class AddStatusToPanel < ActiveRecord::Migration[5.1]
  def change
    safety_assured do
      add_column :panels, :status, :string, default: Panel.statuses[:active]
    end
  end
end
