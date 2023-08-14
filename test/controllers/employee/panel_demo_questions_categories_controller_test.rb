# frozen_string_literal: true

require 'test_helper'

class Employee::PanelDemoQuestionsCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:recruitment)
    @demo_question = demo_questions(:standard)
    demo_question_category = demo_questions_category(:standard)
    demo_question_category.update(name: 'Pro')
  end

  describe '#edit' do
    it 'should load the edit page' do
      get edit_panel_question_categories_url(@demo_question.panel, @demo_question)

      assert_response :ok
    end
  end

  describe '#update' do
    it 'should update the demo question' do
      put panel_question_categories_url(@demo_question.panel, @demo_question), params: { demo_questions_category: { name: 'Pro' } }

      @demo_question.reload
      assert_equal @demo_question.demo_questions_category.name, 'Pro'
    end

    it 'renders edit page on failure to update' do
      DemoQuestion.any_instance.expects(:update).returns(false).once
      put panel_question_categories_url(@demo_question.panel, @demo_question), params: { demo_questions_category: { name: 'Pro' } }

      assert_template :edit
    end
  end
end
