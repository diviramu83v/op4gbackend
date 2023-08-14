# frozen_string_literal: true

require 'test_helper'

class Employee::PanelDemoOptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:recruitment)
    @demo_question = demo_questions(:standard)
  end

  describe '#new' do
    it 'should load the new page' do
      get new_panel_question_option_url(@demo_question.panel, @demo_question)

      assert_response :ok
    end
  end

  describe '#edit' do
    setup do
      @demo_option = demo_options(:standard)
    end

    it 'should load the edit page' do
      get edit_panel_question_option_url(@demo_option.panel, @demo_option.demo_question, @demo_option)

      assert_response :ok
    end
  end

  describe '#create' do
    it 'should create a demo option' do
      assert_difference -> { @demo_question.demo_options.count } do
        post panel_question_options_url(@demo_question.panel, @demo_question),
             params: { demo_option: { label: 'test option', sort_order: '2' } }
      end
    end

    test 'create redirect and flash' do
      post panel_question_options_url(@demo_question.panel, @demo_question),
           params: {
             demo_option: { label: 'test option', sort_order: '2' },
             add_another: true
           }

      assert_redirected_to new_panel_question_option_url(@demo_question.panel, @demo_question)
      assert_equal 'Demo option successfully added', flash[:notice]
    end

    test 'create does not save and renders #new' do
      DemoOption.any_instance.expects(:save).returns(false)

      post panel_question_options_url(@demo_question.panel, @demo_question),
           params: { demo_option: { label: 'test option', sort_order: '2' } }

      assert_response :ok
      assert_template :new
    end
  end

  describe '#update' do
    setup do
      @demo_option = demo_options(:standard)
    end

    it 'should update a demo option' do
      patch panel_question_option_url(@demo_option.panel, @demo_option.demo_question, @demo_option),
            params: { demo_option: { label: 'test update', sort_order: 1 } }

      @demo_option.reload
      assert_equal @demo_option.label, 'test update'
    end

    test 'update redirect and flash' do
      patch panel_question_option_url(@demo_option.panel, @demo_option.demo_question, @demo_option),
            params: {
              demo_option: { label: 'test update', sort_order: 1 },
              add_another: true
            }

      assert_redirected_to new_panel_question_option_url(@demo_option.panel, @demo_option.demo_question)
      assert_equal 'Demo option successfully added', flash[:notice]
    end

    test 'update does not save and renders #edit' do
      DemoOption.any_instance.expects(:save).returns(false)

      patch panel_question_option_url(@demo_option.panel, @demo_option.demo_question, @demo_option),
            params: { demo_option: { label: 'test update', sort_order: 1 } }

      assert_response :ok
      assert_template :edit
    end
  end
end
