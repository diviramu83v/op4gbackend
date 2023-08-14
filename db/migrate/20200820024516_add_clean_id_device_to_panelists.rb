# frozen_string_literal: true

class AddCleanIdDeviceToPanelists < ActiveRecord::Migration[5.2]
  def change
    add_reference :panelists, :clean_id_device, foreign_key: true
  end
end
