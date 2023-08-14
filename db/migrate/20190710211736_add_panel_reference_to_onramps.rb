# frozen_string_literal: true

class AddPanelReferenceToOnramps < ActiveRecord::Migration[5.1]
  def change
    add_reference :onramps, :panel, foreign_key: true
  end
end
