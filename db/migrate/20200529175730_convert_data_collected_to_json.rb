# frozen_string_literal: true

class ConvertDataCollectedToJson < ActiveRecord::Migration[5.2]
  def change
    remove_column :traffic_checks, :data_collected, :string
    add_column :traffic_checks, :data_collected, :json
  end
end
