# frozen_string_literal: true

class AddDemoQuestionsToNewPanel < ActiveRecord::Migration[5.1]
  PROFESSIONAL_DEMO_QUESTIONS = [
    ['Which best describes the organization or industry in which you work?', 14],
    ['Which best describes your job title?', 15],
    ['Size of company in total number of employees at all locations', 19],
    ['Size of company in revenue dollars', 20],
    ['What is your total annual household income, before taxes?', 28],
    ['Which best describes your occupation?', 16],
    ['Number of computers at all company locations worldwide', 18]
  ].freeze

  GENERAL_DEMO_QUESTIONS = [
    ['In which state do you currently reside?', 96],
    ['What is your gender?', 1],
    ['What is your current employment status?', 13],
    ['What is the highest level of education you\'ve completed?', 10],
    ['Individual net worth excluding home and autos', 6],
    ['Are you of Hispanic, Latino, or Spanish origin?', 3],
    ['What is your ethnicity?', 97],
    ['What is your current marital status?', 2]
  ].freeze

  HOME_DEMO_QUESTIONS = [
    ['How many children do you have under the age of 18?', 21],
    ['How many people in your household are 12-17 years old?', 24],
    ['How many people in your household are 18-24 years old?', 25],
    ['Do you own or rent your current residence?', 27],
    ['Do you own or lease a vehicle?', 31],
    ['Do you plan to buy or lease a NEW vehicle?', 32],
    ['Who in your household is responsible for making the majority of the decisions about day-to-day purchases?', 29]
  ].freeze

  YES_OR_NO_QUESTIONS = [
    ['Do you suffer from allergies, asthma, or respiratory condition', 'Respiratory'],
    ['Do you suffer from a kidney or bladder ailment', 'Kidney'],
    ['Do you suffer from a blood disorder', 'Blood'],
    ['Do you suffer from men\'s health issues', 'Men'],
    ['Do you suffer from a bone or joint condition', 'Bone'],
    ['Do you suffer from a neurological or mental health condition', 'Mental'],
    ['Do you suffer from cancer or cancer-related condition', 'Cancer'],
    ['Do you suffer from skin conditions', 'Skin'],
    ['Do you suffer from a chronic pain ailment', 'Chronic'],
    ['Do you suffer from a sleep disorder', 'Sleep'],
    ['Do you suffer from diabetes', 'Diabetes'],
    ['Do you suffer from a thyroid condition', 'Thyroid'],
    ['Do you suffer from a stomach, bowel, or digestion ailment', 'Stomach'],
    ['Do you suffer from an eye, vision, or hearing condition', 'Vision'],
    ['Do you suffer from women\'s health issue', 'Women'],
    ['Do you suffer from a heart or cardio-vascular condition', 'Heart']
  ].freeze

  def up
    panel = Panel.find_by(name: 'New_Op4G')
    professional_category = panel.demo_questions_categories.find_by(name: 'Professional')
    general_category = panel.demo_questions_categories.find_by(name: 'General')
    home_category = panel.demo_questions_categories.find_by(name: 'Home')
    health_category = panel.demo_questions_categories.find_by(name: 'Health')
    create_demo_questions_for_category(professional_category, PROFESSIONAL_DEMO_QUESTIONS)
    create_demo_questions_for_category(general_category, GENERAL_DEMO_QUESTIONS)
    create_demo_questions_for_category(home_category, HOME_DEMO_QUESTIONS)
    YES_OR_NO_QUESTIONS.each.with_index(1) do |question_array, index|
      demo_question = health_category.demo_questions.create(input_type: 'single', sort_order: index, label: question_array.last, body: question_array.first)
      demo_question.demo_options.create(label: 'Yes', sort_order: 1)
      demo_question.demo_options.create(label: 'No', sort_order: 2)
    end
  end

  def down
    DemoQuestionsCategory.find_by(name: 'Professional').demo_questions.destroy_all
    DemoQuestionsCategory.find_by(name: 'General').demo_questions.destroy_all
    DemoQuestionsCategory.find_by(name: 'Home').demo_questions.destroy_all
    DemoQuestionsCategory.find_by(name: 'Health').demo_questions.destroy_all
  end

  private

  def create_demo_questions_for_category(category, demo_questions_array)
    demo_questions_array.each do |demo_question_array|
      demo_question = DemoQuestion.find(demo_question_array.last)
      new_demo_question = category.demo_questions.create(input_type: 'single',
                                                         sort_order: demo_question.sort_order,
                                                         label: demo_question.label,
                                                         body: demo_question_array.first)
      add_demo_options_to_demo_question(demo_question, new_demo_question)
    end
  end

  def add_demo_options_to_demo_question(demo_question, new_demo_question)
    demo_question.demo_options.find_each do |demo_option|
      new_demo_question.demo_options.create(label: demo_option.label, sort_order: demo_option.sort_order)
    end
  end
end
