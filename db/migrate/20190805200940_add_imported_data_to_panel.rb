# frozen_string_literal: true

class AddImportedDataToPanel < ActiveRecord::Migration[5.1]
  def change
    add_column :panels, :imported_data, :text
  end
end
