# frozen_string_literal: true

require 'test_helper'

class DemoQuestionTest < ActiveSupport::TestCase
  describe '.not_archived' do
    it 'returns standard questions' do
      assert_difference -> { DemoQuestion.not_archived.count } do
        DemoQuestion.create(
          label: Faker::Color.color_name,
          input_type: 'single',
          sort_order: Faker::Number.between(from: 1, to: 100),
          body: 'question body',
          demo_questions_category: demo_questions_category(:standard)
        )
      end
    end

    it 'returns multiple input questions' do
      assert_difference -> { DemoQuestion.not_archived.count } do
        DemoQuestion.create(
          label: Faker::Color.color_name,
          input_type: 'multiple',
          sort_order: Faker::Number.between(from: 1, to: 100),
          body: 'question body',
          demo_questions_category: demo_questions_category(:standard)
        )
      end
    end

    it 'does not return archived questions' do
      assert_no_difference -> { DemoQuestion.not_archived.count } do
        DemoQuestion.create(
          label: Faker::Color.color_name,
          input_type: 'single',
          sort_order: Faker::Number.between(from: 1, to: 100),
          body: 'question body',
          demo_questions_category: demo_questions_category(:standard),
          archived_at: Time.now.utc
        )
      end
    end
  end

  describe '.required_for_panelsit' do
    setup do
      @panelist = panelists(:standard)
    end

    it 'returns standard questions' do
      assert_difference -> { DemoQuestion.required_for_panelist(@panelist).count } do
        DemoQuestion.create(
          label: Faker::Color.color_name,
          input_type: 'single',
          sort_order: Faker::Number.between(from: 1, to: 100),
          body: 'question body',
          demo_questions_category: demo_questions_category(:standard)
        )
      end
    end

    it 'does not return archived questions' do
      assert_no_difference -> { DemoQuestion.required_for_panelist(@panelist).count } do
        DemoQuestion.create(
          label: Faker::Color.color_name,
          input_type: 'single',
          sort_order: Faker::Number.between(from: 1, to: 100),
          body: 'question body',
          demo_questions_category: demo_questions_category(:standard),
          archived_at: Time.now.utc
        )
      end
    end
  end
end
