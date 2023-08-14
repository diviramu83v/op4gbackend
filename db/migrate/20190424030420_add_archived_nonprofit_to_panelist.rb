# frozen_string_literal: true

class AddArchivedNonprofitToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_reference :panelists, :archived_nonprofit, foreign_key: { to_table: :nonprofits }
  end
end
