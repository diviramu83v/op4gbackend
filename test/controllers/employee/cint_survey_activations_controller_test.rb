# frozen_string_literal: true

require 'test_helper'

class Employee::CintSurveyActivationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @cint_survey = cint_surveys(:standard)
    @cint_survey.onramp = onramps(:cint)
  end

  describe '#create' do
    it 'should update activated_at' do
      assert_nil @cint_survey.activated_at
      stub_request(:post, 'https://fuse.cint.com/ordering/surveys').to_return(status: 200)

      post cint_survey_cint_survey_activations_url(@cint_survey)
      @cint_survey.reload

      assert_not_nil @cint_survey.activated_at
      assert_equal @cint_survey.status, 'waiting'
    end

    it 'should update status from paused to live' do
      stub_request(:patch, 'https://fuse.cint.com/ordering/surveys/227').to_return(status: 200)
      @cint_survey.update!(activated_at: Time.now.utc, status: 'paused')
      assert_not_nil @cint_survey.activated_at

      post cint_survey_cint_survey_activations_url(@cint_survey)
      @cint_survey.reload

      assert_equal @cint_survey.status, 'live'
    end
  end

  describe '#destroy' do
    it 'should update status from live to paused' do
      stub_request(:patch, 'https://fuse.cint.com/ordering/surveys/227').to_return(status: 200)

      delete cint_survey_activation_url(@cint_survey)
      @cint_survey.reload

      assert_equal @cint_survey.status, 'paused'
    end
  end
end
