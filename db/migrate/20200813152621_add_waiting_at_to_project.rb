# frozen_string_literal: true

class AddWaitingAtToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :waiting_at, :datetime
  end
end
