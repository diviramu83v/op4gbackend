# frozen_string_literal: true

class AddLastInvitedAtToPanelist < ActiveRecord::Migration[5.2]
  def change
    add_column :panelists, :last_invited_at, :datetime
  end
end
