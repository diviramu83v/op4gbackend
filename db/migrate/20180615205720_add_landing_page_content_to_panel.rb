# frozen_string_literal: true

class AddLandingPageContentToPanel < ActiveRecord::Migration[5.1]
  def change
    add_column :panels, :landing_page_content, :text
  end
end
