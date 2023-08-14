# frozen_string_literal: true

class AddDemoOptionsToCountryPanels < ActiveRecord::Migration[5.1]
  def change
    new_panel = Panel.find_by(name: 'New_Op4G')
    ['Op4G-CA', 'Op4G-UK', 'Op4G-DE', 'Op4G-FR', 'Op4G-ES', 'Op4G-IT', 'Op4G-AU'].each do |panel_name|
      panel = Panel.find_by(name: panel_name)
      panel.demo_questions.find_each do |demo_question|
        next if %w[Province Region State].include?(demo_question.label)

        base_demo_question = new_panel.demo_questions.find_by(label: demo_question.label)
        next if base_demo_question.blank?

        base_demo_question.demo_options.find_each do |demo_option|
          demo_question.demo_options.create(label: demo_option.label, sort_order: demo_option.sort_order)
        end
      end
    end
  end
end
