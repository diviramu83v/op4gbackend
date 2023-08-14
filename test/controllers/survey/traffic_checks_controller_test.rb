# frozen_string_literal: true

require 'test_helper'

class Survey::TrafficStepsControllerTest < ActionDispatch::IntegrationTest
  describe 'pre-survey path' do
    setup do
      @onramp = onramps(:testing)
      @project = @onramp.project
      @uid = 'test1'
    end

    describe 'clean id' do
      setup do
        @onramp.update!(check_recaptcha: false, check_prescreener: false, check_clean_id: true)
      end

      it 'should pass clean id' do
        CleanIdDataVerification.any_instance.stubs(:fails_any_checks?).returns(false)
        start_onramp
        load_clean_id
        fake_clean_id_completion
        load_next_step
        assert_redirected_to @onboarding.survey_url_with_parameters
      end

      it 'should fail clean id' do
        FinalUrlRedirect.any_instance
                        .expects(:failed_traffic_steps_url)
                        .returns('/failed-path')
                        .at_least_once
        start_onramp
        load_clean_id
        fake_clean_id_completion
        load_next_step
        assert_redirected_to '/failed-path'
      end
    end

    describe 'recaptcha' do
      setup do
        @onramp.update!(check_recaptcha: true, check_prescreener: false, check_clean_id: false)
      end

      it 'should pass recaptcha' do
        Recaptcha.any_instance.stubs(:token_invalid?).returns(false)
        start_onramp
        load_recaptcha
        load_next_step
        assert_redirected_to @onboarding.survey_url_with_parameters
      end

      it 'should fail recaptcha' do
        FinalUrlRedirect.any_instance
                        .expects(:failed_traffic_steps_url)
                        .returns('/failed-path')
                        .at_least_once
        Recaptcha.any_instance.stubs(:token_invalid?).returns(true)
        start_onramp
        load_recaptcha
        load_next_step
        assert_redirected_to '/failed-path'
      end
    end

    describe 'prescreener' do
      setup do
        @onramp.update!(check_recaptcha: false, check_prescreener: true, check_clean_id: false)
      end

      it 'should get redirected into the prescreener' do
        start_onramp
        load_next_step
        assert_redirected_to new_survey_screener_step_question_url(@onboarding.next_prescreener_question&.token)
      end

      it 'should skip the prescreener and go to the next step' do
        start_onramp
        @onboarding.prescreener_questions.destroy_all
        load_next_step
        assert_redirected_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze&.token)
      end

      it 'should pass the prescreener' do
        start_onramp
        load_next_step
        pass_the_prescreener
        load_next_step
        assert_redirected_to @onboarding.survey_url_with_parameters
      end

      it 'should fail the prescreener' do
        start_onramp
        load_next_step
        fail_the_prescreener
        load_next_step
        assert_redirected_to survey_screened_url(token: @onboarding.response_token)
      end

      it 'should fail the prescreener schlesinger' do
        @onramp.update!(category: 'schlesinger')
        start_onramp
        load_next_step
        fail_the_prescreener
        load_next_step
        assert_redirected_to FinalUrlRedirect.new(onboarding: @onboarding).final_url
      end
    end

    test 'gate survey' do
      Recaptcha.any_instance.stubs(:token_invalid?).returns(false)
      CleanIdDataVerification.any_instance.stubs(:fails_any_checks?).returns(false)
      @onramp.update!(
        check_recaptcha: true,
        check_clean_id: true,
        check_gate_survey: true
      )

      start_onramp
      load_clean_id
      fake_clean_id_completion
      load_recaptcha

      # gate survey testing
      load_next_step
      assert_template :gate_survey
      assert_difference -> { @onboarding.traffic_checks.count } do
        post survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token),
             params: { step: { gender: 'female' } }
      end

      load_next_step # analyze

      @onboarding.reload
      assert_equal @onboarding.status, Onboarding.statuses[:survey_started]
    end
  end

  describe 'post-survey path' do
    setup do
      @onboarding = onboardings(:complete)
      @survey = surveys(:standard)
      @project = @survey.project
    end

    test 'standard flow' do
      Onboarding.any_instance.stubs(:collect_followup_data?).returns(true)
      FinalUrlRedirect.any_instance
                      .expects(:final_url)
                      .returns('/happy-ending')
                      .at_least_once

      get survey_response_url(@project.complete_response, uid: @onboarding.token, return_key: 'asdf')
      assert_redirected_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token)
      load_next_step # analyze
      load_next_step # follow up

      assert_difference -> { @onboarding.traffic_checks.count } do
        post survey_step_check_url(
          step: {
            token: @onboarding.next_traffic_step_or_analyze.token,
            email: 'test@testmail.com'
          }
        )
      end

      # redirect
      load_next_step
      assert_redirected_to '/happy-ending'
    end

    test 'security failure' do
      FinalUrlRedirect.any_instance
                      .expects(:failed_traffic_steps_url)
                      .returns('/security-failure')
                      .at_least_once

      get survey_response_url(@project.complete_response, uid: @onboarding.token, return_key: 'asdf')
      assert_redirected_to new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token)

      load_next_step
      assert_redirected_to '/security-failure'
    end
  end

  describe 'step already started error' do
    it 'should be redirected to failed traffic step route on new' do
      @onboarding = onboardings(:standard)
      @traffic_step = @onboarding.traffic_steps.find_by(category: 'clean_id')

      get new_survey_step_check_url(@traffic_step.token), params: {}
      assert_redirected_to FinalUrlRedirect.new(onboarding: @onboarding).failed_traffic_steps_url
    end
  end

  private

  def start_onramp
    if @onramp.schlesinger?
      get survey_onramp_url(@onramp.token, pid: @uid)
    else
      get survey_onramp_url(@onramp.token, uid: @uid)
    end
    @onboarding = Onboarding.find_by(uid: @uid)
    assert @onboarding.present?
  end

  def load_clean_id
    load_next_step
    assert_template :clean_id
  end

  def fake_clean_id_completion
    assert_difference -> { @onboarding.traffic_checks.count } do
      get survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token, data: {})
    end
  end

  def pass_the_prescreener
    @onboarding.prescreener_questions.each do |prescreener_question|
      prescreener_question.update(selected_answers: prescreener_question.target_answers)
      prescreener_question.complete!
    end
  end

  def fail_the_prescreener
    @onboarding.prescreener_questions.each do |prescreener_question|
      bad_answer = prescreener_question.answer_options - prescreener_question.target_answers
      prescreener_question.update(selected_answers: [bad_answer.first])
      prescreener_question.complete!
    end
  end

  def load_recaptcha
    load_next_step
    assert_template :recaptcha

    assert_difference -> { @onboarding.traffic_checks.count } do
      post survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token)
    end
  end

  def load_next_step
    assert_difference -> { @onboarding.traffic_checks.count } do
      get new_survey_step_check_url(@onboarding.next_traffic_step_or_analyze.token)
    end
  end
end
