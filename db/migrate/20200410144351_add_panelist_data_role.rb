# frozen_string_literal: true

class AddPanelistDataRole < ActiveRecord::Migration[5.2]
  def change
    Role.create!(name: 'Panelist data')
  end
end
