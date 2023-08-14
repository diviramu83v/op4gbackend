# frozen_string_literal: true

class AddFirstNameToExpertRecruits < ActiveRecord::Migration[5.2]
  def change
    add_column :expert_recruits, :first_name, :string
  end
end
