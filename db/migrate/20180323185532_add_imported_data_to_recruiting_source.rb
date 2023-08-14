# frozen_string_literal: true

class AddImportedDataToRecruitingSource < ActiveRecord::Migration[5.1]
  def change
    add_column :recruiting_sources, :imported_data, :text
  end
end
