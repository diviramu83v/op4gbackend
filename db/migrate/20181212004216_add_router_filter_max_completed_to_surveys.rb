# frozen_string_literal: true

class AddRouterFilterMaxCompletedToSurveys < ActiveRecord::Migration[5.1]
  def change
    add_column :surveys, :router_filter_max_completed, :integer
  end
end
