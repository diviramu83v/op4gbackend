# frozen_string_literal: true

class AddLoiToSurvey < ActiveRecord::Migration[5.1]
  def change
    add_column :surveys, :loi, :integer
  end
end
