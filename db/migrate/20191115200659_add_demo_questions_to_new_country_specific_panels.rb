# frozen_string_literal: true

class AddDemoQuestionsToNewCountrySpecificPanels < ActiveRecord::Migration[5.1]
  def up
    new_panel = Panel.find_by(name: 'New_Op4G')

    new_panel.demo_questions.find_each do |demo_question|
      ['Op4G-CA', 'Op4G-UK', 'Op4G-DE', 'Op4G-FR', 'Op4G-ES', 'Op4G-IT', 'Op4G-AU'].each do |panel_name|
        panel = Panel.find_by(name: panel_name)
        demo_question_category = panel.demo_questions_categories.find { |category| category.name.include?(demo_question.demo_questions_category.name) }
        demo_question_category.demo_questions.create(input_type: 'single',
                                                     sort_order: demo_question.sort_order,
                                                     label: demo_question.label,
                                                     body: demo_question.body)
      end
    end
  end

  def down
    ['Op4G-CA', 'Op4G-UK', 'Op4G-DE', 'Op4G-FR', 'Op4G-ES', 'Op4G-IT', 'Op4G-AU'].each do |panel_name|
      panel = Panel.find_by(name: panel_name)
      panel.demo_questions_categories.find_each do |demo_questions_category|
        demo_questions_category.demo_questions.destroy_all
      end
    end
  end
end
