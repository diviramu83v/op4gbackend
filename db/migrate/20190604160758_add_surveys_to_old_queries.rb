# frozen_string_literal: true

class AddSurveysToOldQueries < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def up
    DemoQuery.where(survey: nil).find_each do |query|
      query.set_survey
      query.save!
    end
  end
end
