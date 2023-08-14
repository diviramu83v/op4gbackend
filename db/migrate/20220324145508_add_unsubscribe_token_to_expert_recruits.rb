# frozen_string_literal: true

class AddUnsubscribeTokenToExpertRecruits < ActiveRecord::Migration[5.2]
  def change
    add_column :expert_recruits, :unsubscribe_token, :string
  end
end
