# frozen_string_literal: true

require 'test_helper'

class DemoAnswerTest < ActiveSupport::TestCase
  before do
    @demo_question_categories = []
    @first_cat_demo_questions = []
    @first_cat_archived_demo_questions = []
    @second_cat_demo_questions = []
    @archived_demo_questions = []

    2.times do
      @demo_question_categories << DemoQuestionsCategory.create(
        panel: Panel.create(
          name: Faker::Name.unique.first_name,
          slug: Faker::Name.unique.first_name.downcase,
          country: Country.create(name: 'United States', slug: 'us')
        ),
        name: 'demo question name',
        slug: 'demo question slug',
        sort_order: Faker::Number.between(from: 1, to: 100)
      )

      @first_cat_demo_questions << DemoQuestion.create(
        label: Faker::Color.color_name,
        input_type: 'single',
        sort_order: Faker::Number.between(from: 1, to: 100),
        body: 'question body',
        demo_questions_category: @demo_question_categories.first
      )

      @first_cat_archived_demo_questions << DemoQuestion.create(
        label: Faker::Color.color_name,
        input_type: 'single',
        sort_order: Faker::Number.between(from: 1, to: 100),
        body: 'question body',
        demo_questions_category: @demo_question_categories.first,
        archived_at: Time.now.utc
      )

      @second_cat_demo_questions << DemoQuestion.create(
        label: Faker::Color.color_name,
        input_type: 'single',
        sort_order: Faker::Number.between(from: 1, to: 100),
        body: 'question body',
        demo_questions_category: @demo_question_categories.last
      )

      @archived_demo_questions << DemoQuestion.create(
        label: Faker::Color.color_name,
        input_type: 'single',
        sort_order: Faker::Number.between(from: 1, to: 100),
        body: 'question body',
        archived_at: Time.now.utc
      )
    end
  end

  it 'has a "for category" scope that only returns unarchived questions that belong to the provided category' do
    DemoAnswer.for_category(@demo_question_categories.first).count == 2
  end
end
