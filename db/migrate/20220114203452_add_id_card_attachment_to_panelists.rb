# frozen_string_literal: true

class AddIdCardAttachmentToPanelists < ActiveRecord::Migration[5.2]
  def change
    add_attachment :panelists, :id_card
  end
end
