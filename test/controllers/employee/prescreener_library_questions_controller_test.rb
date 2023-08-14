# frozen_string_literal: true

require 'test_helper'

class Employee::PrescreenerLibraryQuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @prescreener_library_question = prescreener_library_questions(:standard)
  end

  describe '#index' do
    it 'should load the page' do
      get prescreener_library_questions_url

      assert_response :ok
    end
  end

  describe '#new' do
    it 'should load the page' do
      get new_prescreener_library_question_url(@prescreener_library_question)

      assert_response :ok
    end
  end

  describe '#edit' do
    it 'should load the page' do
      get edit_prescreener_library_question_url(@prescreener_library_question)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      @params = {
        prescreener_library_question: {
          question: 'What are your favorite colors?',
          answers: "blue\r\nred"
        }
      }
    end

    it 'should create a prescreener library question and redirect to the index page' do
      assert_difference -> { PrescreenerLibraryQuestion.count } do
        post prescreener_library_questions_url(@prescreener_library_question), params: @params
      end
      assert_redirected_to prescreener_library_questions_url
    end

    it 'should fail to create prescreener library question' do
      @params = {
        prescreener_library_question: {
          question: nil,
          answers: "blue\r\nred"
        }
      }

      assert_no_difference -> { PrescreenerLibraryQuestion.count } do
        post prescreener_library_questions_url(@prescreener_library_question), params: @params
      end
    end
  end

  describe '#update' do
    setup do
      @updated_params = {
        prescreener_library_question: {
          answers: "green\r\nyellow"
        }
      }
    end

    it 'should update the question' do
      put prescreener_library_question_url(@prescreener_library_question),
          params: @updated_params
      @prescreener_library_question.reload

      assert_equal %w[green yellow], @prescreener_library_question.answers
      assert_redirected_to prescreener_library_questions_url
    end
  end

  describe '#destroy' do
    it 'should delete the selected question' do
      assert_difference -> { PrescreenerLibraryQuestion.count }, -1 do
        delete prescreener_library_question_url(@prescreener_library_question)
      end
    end
  end
end
