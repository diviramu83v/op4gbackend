# frozen_string_literal: true

require 'test_helper'

class Employee::LibraryQuestionSelectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @survey = surveys(:standard)
    @prescreener_library_question = prescreener_library_questions(:standard)
  end

  describe '#index' do
    it 'should load the page' do
      get survey_library_question_selections_url(@survey)

      assert_response :ok
    end
  end

  describe '#new' do
    it 'should load the page' do
      get new_survey_library_question_selection_url(@survey, library_question: @prescreener_library_question.id)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      @params = {
        prescreener_question_template: {
          body: 'What are your favorite colors?',
          answers: "blue\r\nred\r\ngreen",
          question_type: 'single_answer',
          passing_criteria: 'pass_if_any_selected'
        }
      }
    end

    it 'should create a prescreener question template and redirect to the index page' do
      assert_difference -> { @survey.prescreener_question_templates.count } do
        post survey_library_question_selections_url(@survey), params: @params
      end

      @prescreener_question = @survey.prescreener_question_templates.last

      assert_redirected_to prescreener_question_answers_url(@prescreener_question)
    end

    it 'should fail to create prescreener question template' do
      @params = {
        prescreener_question_template: {
          body: 'What are your favorite colors?',
          answers: "blue\r\nred\r\ngreen",
          question_type: 'single_answer',
          passing_criteria: nil
        }
      }

      assert_no_difference -> { @survey.prescreener_question_templates.count } do
        post survey_library_question_selections_url(@survey), params: @params
      end
    end
  end
end
