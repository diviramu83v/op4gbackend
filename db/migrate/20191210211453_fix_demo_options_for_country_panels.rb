# frozen_string_literal: true

class FixDemoOptionsForCountryPanels < ActiveRecord::Migration[5.1]
  MAPPING_HASH = {
    ethnicity: 'Ethnicity',
    income: 'Household Income',
    education: 'Highest Level of Education'
  }.freeze

  def change
    canada_panel = Panel.find_by(name: 'Op4G-CA')
    united_kingdom_panel = Panel.find_by(name: 'Op4G-UK')
    germany_panel = Panel.find_by(name: 'Op4G-DE')
    france_panel = Panel.find_by(name: 'Op4G-FR')
    spain_panel = Panel.find_by(name: 'Op4G-ES')
    italy_panel = Panel.find_by(name: 'Op4G-IT')
    australia_panel = Panel.find_by(name: 'Op4G-AU')

    [canada_panel, united_kingdom_panel, germany_panel, france_panel, spain_panel, italy_panel, australia_panel].each do |panel|
      MAPPING_HASH.each_key do |label|
        new_demo_question = panel.demo_questions.find_by(label: label.to_s.humanize)
        old_demo_question = DemoQuestion.find_by(label: MAPPING_HASH[label], country_id: panel.country.id)
        next if old_demo_question.blank?

        new_demo_question.demo_options.destroy_all
        old_demo_question.demo_options.find_each do |demo_option|
          new_demo_question.demo_options.create(label: demo_option.label, sort_order: demo_option.sort_order)
        end
      end
    end
  end
end
