# frozen_string_literal: true

class RemoveGetResponseIdFromPanelists < ActiveRecord::Migration[5.2]
  def change
    remove_column :panelists, :get_response_id, :string
  end
end
