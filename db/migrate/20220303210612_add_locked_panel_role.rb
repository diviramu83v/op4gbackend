# frozen_string_literal: true

class AddLockedPanelRole < ActiveRecord::Migration[5.2]
  def change
    Role.create!(name: 'Locked panel')
  end
end
