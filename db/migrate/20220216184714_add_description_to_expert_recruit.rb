# frozen_string_literal: true

class AddDescriptionToExpertRecruit < ActiveRecord::Migration[5.2]
  def change
    add_column :expert_recruits, :description, :string
  end
end
