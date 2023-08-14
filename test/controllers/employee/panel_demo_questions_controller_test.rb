# frozen_string_literal: true

require 'test_helper'

class Employee::PanelDemoQuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:recruitment)
    @demo_question = demo_questions(:standard)
  end

  describe '#new' do
    test 'new page' do
      @panel = panels(:standard)
      get new_panel_question_url(@panel)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      @panel = panels(:standard)
    end

    test '#create demo question' do
      @demo_question_params = {
        demo_question: {
          input_type: 'input',
          sort_order: 1,
          label: 'test',
          body: 'testing',
          demo_questions_category_id: 284_678_023
        }
      }

      assert_difference -> { DemoQuestion.count }, 1 do
        post panel_questions_url(@panel), params: @demo_question_params
      end

      @demo_question = DemoQuestion.last

      assert_redirected_to panel_question_url(@demo_question.panel, @demo_question)
    end

    test '#create demo question failure' do
      DemoQuestion.any_instance.expects(:save).returns(false)

      assert_no_difference -> { DemoQuestion.count } do
        post panel_questions_url(@panel), params: {
          demo_question: {
            input_type: 'input'
          }
        }
      end

      assert_template :new
    end
  end

  describe '#index' do
    it 'should load the index page' do
      get panel_questions_url(@demo_question.panel)

      assert_response :ok
    end
  end

  describe '#show' do
    it 'should load the show page' do
      get panel_question_url(@demo_question.panel, @demo_question)

      assert_response :ok
    end
  end

  describe '#edit' do
    it 'should load the edit page' do
      get edit_panel_question_url(@demo_question.panel, @demo_question)

      assert_response :ok
    end
  end

  describe '#update' do
    it 'should update the demo question' do
      put panel_question_url(@demo_question.panel, @demo_question),
          params: { demo_question: { body: 'new question text' } }

      @demo_question.reload
      assert_equal @demo_question.body, 'new question text'
    end

    test 'update renders #edit' do
      DemoQuestion.any_instance.expects(:update).returns(false)

      put panel_question_url(@demo_question.panel, @demo_question), params: { demo_question: { body: 'new question text' } }

      assert_response :ok
      assert_template :edit
    end
  end
end
