# frozen_string_literal: true

require 'test_helper'

class Survey::PrescreenerChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prescreener_question_single = prescreener_questions(:single_answer)
    @prescreener_question_multi = prescreener_questions(:multi_answer)
    @prescreener_question_open = prescreener_questions(:open_end)
  end

  describe '#new' do
    it 'should load the page' do
      get new_survey_screener_step_question_url(@prescreener_question_single.token)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      @onboarding = onboardings(:standard)
    end

    it 'should answer a single answer question' do
      load_and_sign_in_base_employee

      @params = {
        answer: {
          selected_answer: @prescreener_question_single.target_answers.first
        }
      }
      post survey_screener_step_question_url(@prescreener_question_single.token), params: @params
      @prescreener_question_single.reload

      assert_not @prescreener_question_single.question_failed?
    end

    it 'should answer a multi answer question' do
      @params = {
        answer: {
          checked_answers: [@prescreener_question_multi.target_answers.first]
        }
      }
      post survey_screener_step_question_url(@prescreener_question_multi.token), params: @params
      @prescreener_question_multi.reload

      assert_not @prescreener_question_multi.question_failed?
    end

    it 'should answer an open end question' do
      @params = { answer: { typed_answer: '84111' } }
      post survey_screener_step_question_url(@prescreener_question_open.token), params: @params

      @prescreener_question_open.reload
      assert_not @prescreener_question_open.question_failed?
    end

    it 'should finish the questions and go back to the traffic flow' do
      @params = { answer: { typed_answer: '12345' } }
      @prescreener_question_single.complete!
      @prescreener_question_multi.complete!

      post survey_screener_step_question_url(@prescreener_question_open.token), params: @params

      assert_redirected_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze&.token)
    end

    it 'should fail a prescreener question and continue to the next prescreener question' do
      load_and_sign_in_base_employee

      @params = {
        answer: {
          selected_answer: @prescreener_question_single.answer_options.last
        }
      }

      post survey_screener_step_question_url(@prescreener_question_single.token), params: @params
      @prescreener_question_single.reload

      assert @prescreener_question_single.question_failed?
      assert_redirected_to new_survey_screener_step_question_url(@onboarding.next_prescreener_question.token)
    end
  end
end
