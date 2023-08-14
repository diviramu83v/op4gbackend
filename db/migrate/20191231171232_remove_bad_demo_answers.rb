# frozen_string_literal: true

class RemoveBadDemoAnswers < ActiveRecord::Migration[5.1]
  def change
    safety_assured do
      new_panel = Panel.find_by(slug: 'op4g-us')
      canada_panel = Panel.find_by(name: 'Op4G-CA')
      united_kingdom_panel = Panel.find_by(name: 'Op4G-UK')
      germany_panel = Panel.find_by(name: 'Op4G-DE')
      france_panel = Panel.find_by(name: 'Op4G-FR')
      spain_panel = Panel.find_by(name: 'Op4G-ES')
      italy_panel = Panel.find_by(name: 'Op4G-IT')
      australia_panel = Panel.find_by(name: 'Op4G-AU')

      [canada_panel, united_kingdom_panel, germany_panel, france_panel, spain_panel, italy_panel, australia_panel].each do |panel|
        panel.panelists.find_each do |panelist|
          bad_demo_answers = panelist.demo_answers.joins(:panel).where('panels.id = ?', new_panel.id)
          bad_demo_answers.destroy_all
        end
      end
    end
  end
end
