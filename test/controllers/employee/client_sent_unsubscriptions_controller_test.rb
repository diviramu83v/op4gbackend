# frozen_string_literal: true

require 'test_helper'

class Employee::ClientSentUnsubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @survey = surveys(:standard)
  end

  describe '#show' do
    it 'should load the page' do
      get survey_client_sent_survey_unsubscriptions_url(@survey)

      assert_response :ok
    end

    it 'should export csv' do
      get survey_client_sent_survey_unsubscriptions_url(@survey, format: :csv)

      # check for csv response
      assert_equal controller.headers['Content-Transfer-Encoding'], 'binary'
    end
  end
end
