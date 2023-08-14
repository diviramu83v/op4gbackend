# frozen_string_literal: true

class BackfillPanelistStatusEvents < ActiveRecord::Migration[5.1]
  def change
    Panelist.find_each(&:create_status_event_for_exisiting_panelist)
  end
end
