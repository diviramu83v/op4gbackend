# frozen_string_literal: true

class AddSearchTermsToPanelist < ActiveRecord::Migration[5.1]
  def change
    add_column :panelists, :search_terms, :string
  end
end
