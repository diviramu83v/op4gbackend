# frozen_string_literal: true

require 'test_helper'

class Employee::SurveyBlockReasonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @survey = surveys(:standard)
  end

  describe '#index' do
    it 'should load the page' do
      get survey_block_reasons_url(@survey)

      assert_response :ok
    end
  end
end
