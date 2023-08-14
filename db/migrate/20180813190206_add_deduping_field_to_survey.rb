# frozen_string_literal: true

class AddDedupingFieldToSurvey < ActiveRecord::Migration[5.1]
  def change
    add_column :surveys, :prevent_overlapping_invitations, :boolean, null: false, default: false
  end
end
