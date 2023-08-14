# frozen_string_literal: true

class AddClientTestLinkToSurvey < ActiveRecord::Migration[6.1]
  def change
    add_column :surveys, :client_test_link, :string
  end
end
