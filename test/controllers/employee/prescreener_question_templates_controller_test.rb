# frozen_string_literal: true

require 'test_helper'

class Employee::PrescreenerQuestionTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @survey = surveys(:standard)
    @prescreener_question_template = prescreener_question_templates(:standard)
  end

  describe '#index' do
    it 'should load the page' do
      get survey_prescreener_questions_url(@survey)

      assert_response :ok
    end
  end

  describe '#new' do
    it 'should load the page' do
      get new_survey_prescreener_question_url(@survey)

      assert_response :ok
    end
  end

  describe '#edit' do
    it 'should load the page' do
      get edit_prescreener_question_url(@prescreener_question_template)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      @params = {
        prescreener_question: {
          question_type: 'single_answer',
          passing_criteria: 'pass_if_any_selected',
          body: 'Where are you?'
        }
      }
    end

    it 'should create a prescreener question' do
      assert_difference -> { PrescreenerQuestionTemplate.count } do
        post survey_prescreener_questions_url(@survey), params: @params
      end
    end

    it 'should save and redirect to answers page' do
      assert_difference -> { PrescreenerQuestionTemplate.count } do
        post survey_prescreener_questions_url(@survey), params: @params.merge(add_answers: 'true')
      end
      @prescreener_question = PrescreenerQuestionTemplate.find_by(body: 'Where are you?')

      assert_redirected_to prescreener_question_answers_url(@prescreener_question)
    end

    it 'should fail to create prescreener question' do
      PrescreenerQuestionTemplate.any_instance.expects(:save).returns(false).once
      assert_no_difference -> { PrescreenerQuestionTemplate.count } do
        post survey_prescreener_questions_url(@survey), params: @params
      end

      assert_template :new
    end

    it 'should create a prescreener with pass_if_all_selected and multi_answer' do
      params = {
        prescreener_question: {
          question_type: 'multi_answer',
          passing_criteria: 'pass_if_all_selected',
          body: 'Where are you?'
        }
      }
      assert_difference -> { PrescreenerQuestionTemplate.count } do
        post survey_prescreener_questions_url(@survey), params: params
      end
    end

    it 'should fail to create prescreener question' do
      params = {
        prescreener_question: {
          question_type: 'single_answer',
          passing_criteria: 'pass_if_all_selected',
          body: 'Where are you?'
        }
      }
      assert_no_difference -> { PrescreenerQuestionTemplate.count } do
        post survey_prescreener_questions_url(@survey), params: params
      end

      assert_template :new
    end
  end

  describe '#update' do
    setup do
      @params = {
        prescreener_question: {
          question_type: 'multi_answer'
        }
      }
    end

    it 'should update a prescreener question' do
      patch prescreener_question_url(@prescreener_question_template), params: @params
      @prescreener_question_template.reload

      assert_equal @prescreener_question_template.question_type, 'multi_answer'
    end
  end

  describe '#destroy' do
    test 'delete a prescreener question' do
      delete prescreener_question_url(@prescreener_question_template)
      @prescreener_question_template.reload

      assert @prescreener_question_template.deleted?
    end
  end
end
