# frozen_string_literal: true

class AddRouterFilterStatesToSurvey < ActiveRecord::Migration[5.1]
  def change
    add_column :surveys, :router_filter_states, :string, array: true
    add_column :surveys, :router_filter_incomes, :string, array: true
    add_index :surveys, :router_filter_states, using: 'gin'
    add_index :surveys, :router_filter_incomes, using: 'gin'
  end
end
