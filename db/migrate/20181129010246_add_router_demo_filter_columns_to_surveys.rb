# frozen_string_literal: true

class AddRouterDemoFilterColumnsToSurveys < ActiveRecord::Migration[5.1]
  def change
    add_column :surveys, :router_filter_min_age, :integer
    add_column :surveys, :router_filter_max_age, :integer
    add_column :surveys, :router_filter_gender, :string
  end
end
