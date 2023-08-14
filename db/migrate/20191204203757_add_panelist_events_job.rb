# frozen_string_literal: true

class AddPanelistEventsJob < ActiveRecord::Migration[5.1]
  def up
    Role.create!(name: 'Panelist events')
  end
end
