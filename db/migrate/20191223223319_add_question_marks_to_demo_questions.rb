# frozen_string_literal: true

class AddQuestionMarksToDemoQuestions < ActiveRecord::Migration[5.1]
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
      panel.demo_questions.find_each do |demo_question|
        next if demo_question.body[-1] == '?'

        question = demo_question.body + '?'
        demo_question.update(body: question)
      end
    end
  end
end
