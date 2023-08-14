# frozen_string_literal: true

class RewordSomeDemoQuestions < ActiveRecord::Migration[5.1]
  def change
    new_panel = Panel.find_by(slug: 'op4g-us')
    canada_panel = Panel.find_by(name: 'Op4G-CA')
    united_kingdom_panel = Panel.find_by(name: 'Op4G-UK')
    germany_panel = Panel.find_by(name: 'Op4G-DE')
    france_panel = Panel.find_by(name: 'Op4G-FR')
    spain_panel = Panel.find_by(name: 'Op4G-ES')
    italy_panel = Panel.find_by(name: 'Op4G-IT')
    australia_panel = Panel.find_by(name: 'Op4G-AU')

    [new_panel, canada_panel, united_kingdom_panel, germany_panel, france_panel, spain_panel, italy_panel, australia_panel].each do |panel|
      panel.demo_questions.find_by(label: 'Worth').update(body: 'What is your individual net worth excluding home and autos?')
      panel.demo_questions.find_by(label: 'Revenue').update(body: 'What is the size of the company in revenue dollars?')
      panel.demo_questions.find_by(label: 'Employees').update(body: 'What is the size of the company in total number of employees at all locations?')
      panel.demo_questions.find_by(label: 'Computers').update(body: 'What is the number of computers at all company locations worldwide?')
    end
  end
end
