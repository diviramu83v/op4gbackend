# frozen_string_literal: true

class PopulatePanelSlug < ActiveRecord::Migration[5.1]
  def up
    Panel.find_each do |panel|
      panel.update slug: name.downcase
    end

    change_column_null :panels, :slug, false
  end

  def down
    change_column_null :panels, :slug, true
  end
end
