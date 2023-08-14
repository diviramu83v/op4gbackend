# frozen_string_literal: true

class AddCustomerSurveyIdToDemoQueries < ActiveRecord::Migration[5.1]
  def change
    add_reference :demo_queries, :customer_survey, foreign_key: true
  end
end
