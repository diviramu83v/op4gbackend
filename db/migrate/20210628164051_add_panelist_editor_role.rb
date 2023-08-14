# frozen_string_literal: true

class AddPanelistEditorRole < ActiveRecord::Migration[5.2]
  def change
    Role.create!(name: 'Panelist editor')
  end
end
