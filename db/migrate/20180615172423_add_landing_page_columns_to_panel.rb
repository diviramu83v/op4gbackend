# frozen_string_literal: true

class AddLandingPageColumnsToPanel < ActiveRecord::Migration[5.1]
  def change
    add_column :panels, :slug, :string
    add_column :panels, :landing_page_title, :string
  end
end
