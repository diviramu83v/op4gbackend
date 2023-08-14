# frozen_string_literal: true

class AddUnbrandedFlagToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :unbranded, :boolean
  end
end
