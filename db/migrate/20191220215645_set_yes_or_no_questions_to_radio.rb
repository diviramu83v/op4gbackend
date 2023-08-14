# frozen_string_literal: true

class SetYesOrNoQuestionsToRadio < ActiveRecord::Migration[5.1]
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

      [new_panel, canada_panel, united_kingdom_panel, germany_panel, france_panel, spain_panel, italy_panel, australia_panel].each do |panel|
        demo_questions = panel.demo_questions.select { |question| question.demo_options.count == 2 }
        demo_questions.each do |demo_question|
          demo_question.update(input_type: 'radio')
        end
      end
    end
  end
end
