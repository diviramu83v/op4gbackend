# frozen_string_literal: true

class AddSlugToSurveyResponses < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_response_urls, :slug, :string
  end
end
