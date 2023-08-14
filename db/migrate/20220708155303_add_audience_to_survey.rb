# frozen_string_literal: true

class AddAudienceToSurvey < ActiveRecord::Migration[6.1]
  def change
    add_column :surveys, :audience, :string
  end
end
