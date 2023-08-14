# frozen_string_literal: true

class FixStateOptionsInCountryPanels < ActiveRecord::Migration[5.1]
  def change
    safety_assured do
      [%w[New_Op4G USState], %w[Op4G-CA CARegion], %w[Op4G-AU AURegion], %w[Op4G-DE DERegion], %w[Op4G-FR FRRegion], %w[Op4G-ES ESRegion], %w[Op4G-IT ITRegion]].each do |panel_array|
        new_panel = Panel.find_by(name: panel_array.first)
        new_state_demo_question = new_panel.demo_questions.find_by(label: 'State')
        new_state_demo_question.demo_options.destroy_all
        panelist = Panelist.find { |p| p.country&.name == new_panel.country.name }
        old_panel = panelist.panels.where.not(name: panel_array.first).first
        old_state_demo_question = old_panel.demo_questions.find { |question| question.import_label.include?(panel_array.last) }
        next if old_state_demo_question.blank?

        new_state_demo_question.update(body: old_state_demo_question.body,
                                       label: old_state_demo_question.label)
        old_state_demo_question.demo_options.each do |demo_option|
          new_state_demo_question.demo_options.create(label: demo_option.label, sort_order: demo_option.sort_order)
        end
      end

      uk_panel = Panel.find_by(name: 'Op4G-UK')
      uk_state_demo_question = uk_panel.demo_questions.find_by(label: 'State')
      uk_state_demo_question.demo_options.destroy_all
      uk_state_demo_question.destroy
    end
  end
end
