# frozen_string_literal: true

class AddStatusToSurvey < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :status, :string
  end
end
