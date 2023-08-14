# frozen_string_literal: true

class AddSurveysToOldKeys < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def up
    Key.where(survey: nil).find_each do |key|
      key.set_survey
      key.save!
    end
  end
end
