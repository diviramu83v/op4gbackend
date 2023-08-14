# frozen_string_literal: true

# This removes the 'customer_survey_id' index from demo_queries
class RemoveCustomerSurveyFromDemoQueries < ActiveRecord::Migration[5.2]
  def change
    remove_index :demo_queries, column: :customer_survey_id
    remove_column :demo_queries, :customer_survey_id, :bigint
  end
end
