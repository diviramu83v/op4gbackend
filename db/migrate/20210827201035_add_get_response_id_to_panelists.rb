# frozen_string_literal: true

class AddGetResponseIdToPanelists < ActiveRecord::Migration[5.2]
  def change
    add_column :panelists, :get_response_id, :string
  end
end
