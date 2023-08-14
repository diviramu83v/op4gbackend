# frozen_string_literal: true

class AddClickedAtToExpertRecruits < ActiveRecord::Migration[5.2]
  def change
    add_column :expert_recruits, :clicked_at, :datetime
  end
end
