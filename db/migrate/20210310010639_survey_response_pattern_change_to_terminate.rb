# frozen_string_literal: true

class SurveyResponsePatternChangeToTerminate < ActiveRecord::Migration[5.2]
  def up
    SurveyResponsePattern.find(2).update(slug: 'terminate', name: 'Terminate')
  end

  def down
    SurveyResponsePattern.find(2).update(slug: 'screenout', name: 'Screen Out')
  end
end
