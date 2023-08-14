# frozen_string_literal: true

class AddBypassTokenToSurveyRouter < ActiveRecord::Migration[5.1]
  def up
    add_column :survey_routers, :bypass_token, :string
    add_index :survey_routers, :bypass_token, unique: true
    SurveyRouter.find_each(&:regenerate_bypass_token)
    change_column_null(:survey_routers, :bypass_token, false)
  end

  def down
    remove_column :survey_routers, :bypass_token
  end
end
