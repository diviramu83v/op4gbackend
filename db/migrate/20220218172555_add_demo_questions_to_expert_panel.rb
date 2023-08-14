# frozen_string_literal: true

class AddDemoQuestionsToExpertPanel < ActiveRecord::Migration[5.2]
  def up
    expert_panel = Panel.find_by(slug: 'expert-panel')
    general_category = expert_panel.demo_questions_categories.create(name: 'General', slug: 'general', sort_order: 1)
    professional_category = expert_panel.demo_questions_categories.create(name: 'Professional', slug: 'professional', sort_order: 2)

    general_questions = [
      ['What is your gender?', 'gender', 1],
      ['What is your current marital status?', 'marital', 2],
      ['Are you of Hispanic, Latino, or Spanish origin?', 'origin', 3],
      ['What is your ethnicity?', 'ethnicity', 4],
      ['What is your total annual household income, before taxes?', 'income', 5],
      ['What is the highest level of education you\'ve completed?', 'education', 6]
    ].freeze

    professional_questions = [
      ['What is your current employment status?', 'employment_status', 1],
      ['Which of the following best describes your job level or responsibility?', 'job_level', 2],
      ['Which best describes the industry in which you work?', 'industry', 3],
      ['On a normal workday, how would you describe your work environment?', 'environment', 4],
      ['Which department do you primarily work within at your organization?', 'department', 5],
      ['Which of the following departments/products, if any, do you have influence or decision-making authority over regarding spending/purchasing? Please select all that apply.', 'decision_making', 6],
      ['How many employees does your company currently have - across all locations? Your best guess is fine.', 'employee_count', 7],
      ['What is your company\'s approximate total annual revenue? Your best guess is fine.', 'revenue', 8],
      ['How many years have you spent working for your current company? Your best guess is fine.', 'employment_years', 9],
      ['For how many years has your company been in business? Your best guess is fine.', 'years_in_business', 10]
    ].freeze

    general_questions.each do |question|
      general_category.demo_questions.create(
        input_type: 'single',
        sort_order: question.last,
        label: question.second,
        body: question.first
      )
    end

    professional_questions.each do |question|
      professional_category.demo_questions.create(
        input_type: question.second == 'decision_making' ? 'multiple' : 'single',
        sort_order: question.last,
        label: question.second,
        body: question.first
      )
    end
  end

  def down
    expert_panel = Panel.find_by(slug: 'expert-panel')
    expert_panel.demo_questions_categories.destroy_all
  end
end
