# frozen_string_literal: true

class RemoveCheckRelevantIdFromOnramp < ActiveRecord::Migration[5.2]
  def change
    remove_column :onramps, :check_relevant_id, :boolean
  end
end
