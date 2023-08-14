# frozen_string_literal: true

class RenameUidToCodeOnSurveyRouterSources < ActiveRecord::Migration[5.1]
  def change
    rename_column :survey_router_sources, :uid, :code
  end
end
