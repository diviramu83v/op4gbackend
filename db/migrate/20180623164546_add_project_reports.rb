# frozen_string_literal: true

class AddProjectReports < ActiveRecord::Migration[5.1]
  def change
    # rubocop:disable Style/SymbolProc
    create_table :project_reports do |t|
      t.timestamps
    end
    # rubocop:enable Style/SymbolProc

    add_attachment :project_reports, :report
  end
end
