# frozen_string_literal: true

require 'test_helper'

class Employee::CintSurveyCompletionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @cint_survey = cint_surveys(:standard)
  end

  describe '#create' do
    it 'should update status from paused to live' do
      stub_request(:patch, "https://fuse.cint.com/ordering/surveys/#{@cint_survey.cint_id}").to_return(status: 200)

      post cint_survey_cint_survey_completions_url(@cint_survey)
      @cint_survey.reload

      assert_equal @cint_survey.status, 'complete'
    end
  end
end
