# frozen_string_literal: true

class RemoveEmailVerifiedAt < ActiveRecord::Migration[5.1]
  def change
    remove_column :panelists, :email_verified_at, :datetime
  end
end
