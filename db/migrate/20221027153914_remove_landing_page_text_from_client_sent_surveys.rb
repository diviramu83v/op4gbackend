# frozen_string_literal: true

class RemoveLandingPageTextFromClientSentSurveys < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :client_sent_surveys, :landing_page_text, :string }
  end
end
